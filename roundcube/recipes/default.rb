#
# Cookbook Name:: roundcube
# Recipe:: default
#
# Copyright 2013, Cogini
#

include_recipe 'nginx'
include_recipe 'php::fpm'
include_recipe 'php::module_mcrypt'
include_recipe 'php::module_intl'
include_recipe 'php::module_curl'

if node[:roundcube][:imap_cache] == 'apc'
    include_recipe 'php::module_apc'
end


site_dir = node[:roundcube][:site_dir]
php_user = node[:php][:fpm][:user]


git site_dir do
    repository 'https://github.com/roundcube/roundcubemail.git'
    revision 'release-1.0'
end


if node[:roundcube][:db][:driver] == 'sqlite'

    include_recipe 'php::module_sqlite3'

    directory File.dirname(node[:roundcube][:db][:database]) do
        action :create
        recursive true
        owner php_user
    end

else
    raise NotImplementedError

end


[
    node[:roundcube][:log_dir],
    "#{site_dir}/temp",
].each do |dir|
    directory dir do
        action :create
        recursive true
        owner php_user
    end
end

template "#{site_dir}/config/config.inc.php" do
    source "config.inc.php.erb"
    mode '644'
end

%w{ managesieve password }.each do |p|
    template "#{site_dir}/plugins/#{p}/config.inc.php" do
        source "#{p}-config.inc.php.erb"
        mode '600'
        owner php_user
        only_if { node[:roundcube][:plugins].include?(p) }
    end
end


site = node[:roundcube][:server_names][0]

template "/etc/nginx/sites-available/#{site}" do
    source 'nginx-site.erb'
    mode '644'
    notifies :reload, 'service[nginx]'
end

nginx_site site do
    action :enable
end


template "/etc/logrotate.d/#{site}" do
    mode '644'
    source 'logrotate.erb'
end
