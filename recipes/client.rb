#
# Cookbook Name:: collectd
# Recipe:: client
#
# Copyright 2010, Atari, Inc
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

include_recipe "collectd"

servers =
  if !node[:collectd][:servers].empty?
    node[:collectd][:servers]
  elsif !Chef::Config[:solo]
    search(:node, 'recipes:"collectd::server"').map {|n| n['fqdn'] }
  end
if servers.empty?
  if Chef::Config[:solo]
    raise "No collectd servers found. Please configure at least one server in Chef Solo with collectd['servers']."
  else
    raise "No collectd servers found. Please configure at least one server node using collectd::server."
  end
end

collectd_plugin "network" do
  options :server=>servers
end