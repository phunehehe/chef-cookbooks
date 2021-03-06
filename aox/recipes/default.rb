#
# Cookbook Name:: aox
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'fpm'

include_recipe 'postgresql::server'
package 'postgresql-contrib'


version = '3.2.0'
chef_cache = Chef::Config[:file_cache_path]
package_file = "#{chef_cache}/aox-#{version}.#{node[:fpm][:package_type]}"


unless File.exists?(package_file)

    tar_ball = "archiveopteryx-#{version}.tar.bz2"

    remote_file "#{chef_cache}/#{tar_ball}" do
        source "http://archiveopteryx.org/download/#{tar_ball}"
        action 'create_if_missing'
    end

    bash 'build aox' do
        cwd chef_cache
        code <<-EOH
            tar xvf #{tar_ball}
            cd archiveopteryx-#{version}
            INSTALLROOT=./install make install
            mkdir --parents ./install/etc/init.d
            ln -s /usr/local/archiveopteryx/lib/archiveopteryx ./install/etc/init.d/
            fpm -s dir -t #{node[:fpm][:package_type]} -n aox -v #{version} -p #{package_file} -C install .
        EOH
    end
end


package 'aox' do
    action :install
    source package_file
    provider node[:fpm][:provider]
end

execute '/usr/local/archiveopteryx/lib/installer -s /var/run/postgresql/.s.PGSQL.5432'


postgresql_user 'aox' do
    password node[:aox][:db][:user_password]
end

postgresql_user 'aoxsuper' do
    password node[:aox][:db][:owner_password]
end


template '/usr/local/archiveopteryx/archiveopteryx.conf' do
    mode '600'
    user 'aox'
    notifies :restart, 'service[archiveopteryx]'
end

template '/usr/local/archiveopteryx/aoxsuper.conf' do
    mode '400'
    notifies :restart, 'service[archiveopteryx]'
end


service 'archiveopteryx' do
    action [:enable, :start]
end
