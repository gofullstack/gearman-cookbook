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

%w{ libboost-program-options1.40.0 libevent-1.4-2 libtokyocabinet8 }.each do |pkg|
  package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/gearmand-0.29_x86_64.deb" do
  source 'https://github.com/cramerdev/packages/raw/master/gearmand-0.29_x86_64.deb'
  action :create_if_missing
end

package 'libgearman-dev' do
  action :remove
end

execute "dpkg -i #{Chef::Config[:file_cache_path]}/gearmand-0.29_x86_64.deb" do
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

file node['gearman']['server']['log_file'] do
  owner node['gearman']['server']['user']
  group node['gearman']['server']['group']
  mode '0600'
end

template '/etc/init/gearmand.conf' do
  source 'gearmand.upstart.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'gearmand' do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :status => true
  action [:enable, :start]
end
