#
# Cookbook Name:: application
# Recipe:: wordpress
#
# Copyright 2010, Cramer Development, Inc.
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

app = node.run_state[:current_app]

include_recipe "apache2"

directory app[:deploy_to] do
  owner app[:owner]
  group app[:group]
  mode "0755"
  action :create
end

template "wp-config.php" do
  path "#{app[:deploy_to]}/shared/config/wp-config.php"
  variables(
    :db => app[:databases][node[:app_environment]].merge(:host => "localhost"),
    :keys => app[:wordpress][:keys],
    :url => "http://" + app[:domain_name][node[:app_environment]]
  )
  owner app[:owner]
  group app[:group]
  mode "0644"
end

web_app app[:id] do
  docroot "#{app[:deploy_to]}/current"
  template "web_app.conf.erb"
  cookbook app[:id]
  server_name app[:domain_name][node[:app_environment]]
  log_dir node[:apache][:log_dir]
end

