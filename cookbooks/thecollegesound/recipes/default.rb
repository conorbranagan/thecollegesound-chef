#
# Recipe to setup The College Sound web server
# Copyright 2011, The College Sound
#

# -- Requirements
require_recipe "nginx"
require_recipe "mysql"
require_recipe "gunicorn"

# -- Init file
template "/etc/init/thecollegesound.conf" do
  mode "0755"
  source "thecollegesound.init.erb"
  owner "root"
  group "root"
  variables(
    :settings_path => node[:thecollegesound][:settings_path],
    :workers => node[:thecollegesound][:gunicorn_workers],
  )
end

# -- Settings
directory "/etc/thecollegesound" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

template "/etc/thecollegesound/settings.py" do
  mode "0644"
  source "settings.py.erb"
  owner "root"
  group "root"
  variables(
    :db_host => node[:db][:db_host],
    :db_port => node[:db][:db_port],
    :db_name => node[:db][:db_name],
    :db_user => node[:db][:db_user],
    :db_pass => node[:db][:db_pass],

    :tz_name => node[:common][:tz_name],

    :media_root => node[:thecollegesound][:media_root],
    :admin_media_prefix => node[:thecollegesound][:admin_media],
    :template_dir => node[:thecollegesound][:template_dir],
    :tmp_file_path => node[:thecollegesound][:tmp_path],
  )
end

# -- Start Service
service "thecollegesound" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :restart => true
  action [ :enable, :start ]
end
