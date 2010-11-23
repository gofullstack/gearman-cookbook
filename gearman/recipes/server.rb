#
# Cookbook Name:: gearman
# Recipe:: server
#
# Copyright 2010, Cramer Development, Inc.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "postgresql::server"

user "gearman" do
  shell "/bin/false"
  action :create
end

group "gearman" do
  members ["gearman"]
  append true
  action :create
end

# FIXME: Can't check this out since user doesn't have repo access
#git node[:gearman][:server][:path] do
  #repository node[:gearman][:server][:repo]
  #user "gearman"
  #group "gearman"
  #action :sync
#end

bash "bundle install" do
  cwd node[:gearman][:server][:path]
  code "bundle install"
  user "gearman"
  group "gearman"
end
