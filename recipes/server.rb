#
# Cookbook Name:: gearman
# Recipe:: server
#
# Copyright 2011, Cramer Development
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

packages = value_for_platform(
  %w{ debian ubuntu } => {
    :default => %w{ libboost-program-options1.40.0 libevent-1.4-2 libtokyocabinet8 }
  },
  %w{ centos redhat } => {
    :default => []
  }
)

file_to_install = value_for_platform(
  %w{ debian ubuntu } => { :default => 'gearmand-0.29_x86_64.deb' },
  %w{ centos redhat } => { :default => 'gearmand-0.24_x86_64.rpm' }
)

install_command = value_for_platform(
  %w{ debian ubuntu } => { :default => 'dpkg -i' },
  %w{ centos redhat } => { :default => 'rpm -Uvh' }
)

remote_file "#{Chef::Config[:file_cache_path]}/#{file_to_install}" do
  source "https://github.com/cramerdev/packages/raw/master/#{file_to_install}"
  action :create_if_missing
end

package 'libgearman-dev gearman-job-server' do
  action :remove
end

execute "#{install_command} #{Chef::Config[:file_cache_path]}/#{file_to_install}" do
  creates '/usr/sbin/gearmand'
end

user node['gearman']['server']['user'] do
  comment 'Gearman Job Server'
  home node['gearman']['server']['data_dir']
  shell '/bin/false'
  supports :manage_home => true
end

group node['gearman']['server']['group'] do
  members [node['gearman']['server']['user']]
end

directory node['gearman']['server']['log_dir'] do
  owner node['gearman']['server']['user']
  group node['gearman']['server']['group']
  mode '0770'
end

logrotate_app 'gearmand' do
  path "#{node['gearman']['server']['log_dir']}/*.log"
  frequency 'daily'
  rotate 4
  create "600 #{node['gearman']['server']['user']} #{node['gearman']['server']['group']}"
end

args = "--port=#{node['gearman']['server']['port']} --log-file #{node['gearman']['server']['log_dir']}/gearmand.log --verbose=#{node['gearman']['server']['log_level']}"

case node['platform']
when 'debian', 'ubuntu'
  template '/etc/init/gearmand.conf' do source 'gearmand.upstart.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables :args => args
    notifies :restart, 'service[gearmand]'
  end

  service 'gearmand' do
    provider Chef::Provider::Service::Upstart
    supports :restart => true, :status => true
    action [:enable, :start]
  end
when 'centos', 'redhat'
  include_recipe 'supervisor'
  supervisor_service 'gearmand' do
    start_command "/usr/sbin/gearmand #{args}"
    variables :user => node['gearman']['server']['user']
    supports :restart => true
    action [:enable, :start]
  end
end
