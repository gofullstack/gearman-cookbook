#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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
sysadmin_group = Array.new

# Lock the root user
user "root" do
  action :lock
end

search(:users) do |u|
  sysadmin_group << u['id'] if u["groups"].include?("admin")

  home_dir = "/home/#{u['id']}"

  # Move on to the next user if this one is not specified for this node
  # TODO: Lock the user if they are not included on this node or specified to
  # be locked (#9823)
  next if u[:nodes].is_a?(Array) && !u[:nodes].include?(node.name)

  user u['id'] do
    uid u['uid']
    shell u['shell'] || "/bin/bash"
    comment u['comment']
    supports :manage_home => true
    home home_dir
  end

  directory "#{home_dir}/.ssh" do
    owner u['id']
    group u['id']
    mode "0700"
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner u['id']
    group u['id']
    mode "0600"
    variables :ssh_keys => u['ssh_keys'].join("\n")
  end
end

group "admin" do
  members sysadmin_group
  append true
end
