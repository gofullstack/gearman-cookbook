#
# Cookbook Name:: time
# Recipe:: default
#
# Copyright 2008-2009, Cramer Development, Inc.
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

# NTP Client
case node[:platform]
when "debian","ubuntu"
  package "ntpdate" do
    action :install
  end
when "centos","redhat"
  package "ntp" do
    action :install
  end
end

cron "date" do
  minute "0"
  command "/usr/sbin/ntpdate -4 #{node[:time][:server]}"
end

service "ntp" do
  action :disable
end

# Set time zone
file "/etc/localtime" do
  action :delete
end

link "/etc/localtime" do
  to "/usr/share/zoneinfo/#{node[:time][:zone]}"
end
