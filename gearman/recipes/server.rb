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
  shell "/bin/bash"
  action :create
end

group "gearman" do
  members ["gearman"]
  append true
  action :create
end

# FIXME: Can't check this out since user doesn't have repo access.
#        Just create the dir for now
directory node[:gearman][:server][:path] do
#git node[:gearman][:server][:path] do
  #repository node[:gearman][:server][:repo]
  #user "gearman"
  group "gearman"
  #action :sync
  owner "gearman"
  mode "0755"
end

# TODO: Configure database with attributes
template node[:gearman][:server][:path] + "/config/database.yml" do
  source "database.yml.erb"
  owner "gearman"
  group "gearman"
  mode "0644"
end

bash "bundle install" do
  cwd node[:gearman][:server][:path]
  code "bundle install --deployment"
  creates node[:gearman][:server][:path] + "/vendor/bundle"
  user "gearman"
  group "gearman"
end
