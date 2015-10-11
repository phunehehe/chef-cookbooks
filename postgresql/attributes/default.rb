#
# Cookbook Name:: postgresql
# Attributes:: postgresql
#
# Copyright 2008-2009, Opscode, Inc.
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

case platform
when "debian"

  if platform_version.to_f == 5.0
    default[:postgresql][:version] = "8.3"
  elsif platform_version =~ /squeeze/
    default[:postgresql][:version] = "8.4"
  end

  default[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"

when "ubuntu"

  case
  when platform_version.to_f <= 9.04
    default[:postgresql][:version] = "8.3"
  when platform_version.to_f <= 11.04
    default[:postgresql][:version] = "8.4"
  when platform_version.to_f <= 12.04
    default[:postgresql][:version] = "9.1"
  else
    set[:postgresql][:repo_version] = "9.3"
    default[:postgresql][:version] = "9.3"
  end

  default[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  default[:postgresql][:data_dir] = "/var/lib/postgresql/#{node[:postgresql][:version]}/main"

when "fedora"

  if platform_version.to_f <= 12
    default[:postgresql][:version] = "8.3"
  else
    set[:postgresql][:repo_version] = "8.4"
    default[:postgresql][:version] = "8.4"
  end

  default[:postgresql][:dir] = "/var/lib/pgsql/data"

when "redhat", "centos", "scientific"

  set[:postgresql][:repo_version] = "8.1"
  default[:postgresql][:version] = "8.1"
  default[:postgresql][:dir] = "/var/lib/pgsql/data"

when "suse"

  if platform_version.to_f <= 11.1
    default[:postgresql][:version] = "8.3"
  else
    set[:postgresql][:repo_version] = "8.4"
    default[:postgresql][:version] = "8.4"
  end

  default[:postgresql][:dir] = "/var/lib/pgsql/data"

when "amazon"

  set[:postgresql][:repo_version] = "9.2"
  default[:postgresql][:version] = "9.2"
  default[:postgresql][:dir] = "/var/lib/pgsql9/data"

else
  set[:postgresql][:repo_version] = "8.4"
  default[:postgresql][:version] = "8.4"
  default[:postgresql][:dir]         = "/etc/postgresql/#{node[:postgresql][:version]}/main"
end

default[:postgresql][:client_auth] = []

default[:postgresql][:config][:archive_timeout] = 0
default[:postgresql][:config][:hot_standby] = "off"
default[:postgresql][:config][:listen_addresses] = ["localhost"]
default[:postgresql][:config][:log_min_duration_statement] = 250
default[:postgresql][:config][:max_locks_per_transaction] = 64
default[:postgresql][:config][:max_pred_locks_per_transaction] = 64
default[:postgresql][:config][:max_wal_senders] = "0"
default[:postgresql][:config][:shared_buffers] = "32MB"
default[:postgresql][:config][:wal_keep_segments] = 0
default[:postgresql][:config][:wal_level] = "minimal"

default[:postgresql][:master_host] = nil
set[:postgresql][:is_slave] = node[:postgresql][:master_host]
