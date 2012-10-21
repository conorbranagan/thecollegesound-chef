#
# Recipe to setup The College Sound
# Copyright 2011-2012, The College Sound
#

# -- Requirements
require_recipe "nginx"
require_recipe "mysql::server"
require_recipe "gunicorn"

# -- Packages
package "python-imaging"
package "python-mysqldb"
package "xorg"

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

# -- Directories
directory "/srv/thecollegesound/" do
  owner node[:thecollegesound][:owner_uid]
  mode "0755"
  action :create
end

directory "/srv/thecollegesound/shared" do
  owner node[:thecollegesound][:owner_uid]
  mode "0755"
  action :create
end

directory "/srv/thecollegesound/static" do
  owner node[:thecollegesound][:owner_uid]
  mode "0755"
  action :create
end

directory "/tmp/thecollegesound" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
  action :create
end

# -- DB Setup
bash "create_database" do
  user "root"
  code <<-EOH
  mysql -u root -p#{node[:mysql][:server_root_password]} -e "CREATE DATABASE IF NOT EXISTS #{node[:thecollegesound][:db][:name]}"
  EOH
end

bash "grant_mysql" do
  user "root"
  code <<-EOH
  mysql -u root -p#{node[:mysql][:server_root_password]} -e \
        "GRANT ALL on #{node[:thecollegesound][:db][:name]}.* TO '#{node[:thecollegesound][:db][:user]}'@'localhost' \
          IDENTIFIED BY '#{node[:thecollegesound][:db][:pass]}'"
  EOH
end

# Load the DB from a dump if it exists
bash "load_db" do
  user "root"
  code <<-EOH
  if [ -f /home/#{node[:thecollegesound][:owner_uid]}/tcs_dump.sql ]; then
      # Load from the dump
      mysql -u root -p#{node[:mysql][:server_root_password]} #{node[:thecollegesound][:db][:name]} < /home/#{node[:thecollegesound][:owner_uid]}/tcs_dump.sql
      # Rename the dump so we don't load it twice
      mv /home/#{node[:thecollegesound][:owner_uid]}/tcs_dump.sql /home/#{node[:thecollegesound][:owner_uid]}/tcs_dump.sql.old
  fi
  EOH
end

# -- Settings
template "/srv/thecollegesound/shared/settings.py" do
  mode "0644"
  source "settings.py.erb"
  owner "root"
  group "root"
  variables(
    # Django
    :debug => node[:thecollegesound][:debug],
    :tz_name => node[:thecollegesound][:tz_name],
    :media_root => node[:thecollegesound][:media_root],
    :admin_media_prefix => node[:thecollegesound][:admin_media],
    :template_dir => node[:thecollegesound][:template_dir],
    :tmp_file_path => node[:thecollegesound][:tmp_path],
    :site_root => node[:thecollegesound][:site_root],

    # DB
    :db => node[:thecollegesound][:db],

    # Email
    :admin_email => node[:thecollegesound][:admin_email],
    :email => node[:thecollegesound][:email],

    # Datadog
    :datadog => node[:thecollegesound][:datadog],

    # App settings
    :bin_file_path => node[:thecollegesound][:tmp_path],
    :django_secret_key => node[:thecollegesound][:secret_key],

    # AWS
    :aws => node[:thecollegesound][:aws]
  )
end

# -- Deploy!

#### Move binary into place
#
# Note: Uncomment for a new install and put the wkhtmltoimage and wkhtmltopdf
# binaries into files/default/ because the upload is SLOW if we push the new
# files every time.
#

#cookbook_file "/usr/local/bin/wkhtmltoimage" do
#  action :create_if_missing
#  source "wkhtmltoimage"
#  mode "0655"
#end

#cookbook_file "/usr/local/bin/wkhtmltopdf" do
#  action :create_if_missing
#  source "wkhtmltopdf"
#  mode "0655"
#end

#### Setup the directories

directory "/srv/thecollegesound/static/cache" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
end

directory "/srv/thecollegesound/static/cache/albums" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
end

directory "/srv/thecollegesound/static/show" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
end

directory "/srv/thecollegesound/static/show/show_pic" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
end

directory "/srv/thecollegesound/static/dj_img" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
end

directory "/srv/thecollegesound/static/dj_img/profile_pic" do
  owner node[:thecollegesound][:owner_uid]
  mode "0777"
end

#### Do the SCM deploy

timestamped_deploy "/srv/thecollegesound/" do
  user node[:thecollegesound][:owner_uid]
  repository "#{node[:thecollegesound][:owner_uid]}@localhost:/srv/collegesound.git"
  migrate false
  symlink_before_migrate "settings.py" => "settings.py"
  symlinks "settings.py" => "settings.py"
  before_restart do
    # -- Link statics (css, js, basic images)
    link "/srv/thecollegesound/static/css" do
      to "/srv/thecollegesound/current/collegesound/static/css"
    end

    link "/srv/thecollegesound/static/js" do
      to "/srv/thecollegesound/current/collegesound/static/js"
    end

    link "/srv/thecollegesound/static/images" do
      to "/srv/thecollegesound/current/collegesound/static/images"
    end

    link "/srv/thecollegesound/static/icons" do
      to "/srv/thecollegesound/current/collegesound/static/icons"
    end

    # FIXME: images/ and img/ should be consildated into one directory!
    link "/srv/thecollegesound/static/img" do
      to "/srv/thecollegesound/current/collegesound/static/img"
    end

    # -- Link templates
    link "/srv/thecollegesound/templates" do
      to "/srv/thecollegesound/current/collegesound/templates"
    end

    # -- Link settings
    link "/srv/thecollegesound/current/collegesound/settings.py" do
      to "/srv/thecollegesound/shared/settings.py"
    end

    # -- Install the package
    bash "install_package" do
      user "root"
      cwd "/srv/thecollegesound/current/"
      code <<-EOH
      python setup.py install
      EOH
    end

    # -- Run migration
    bash "run_migration" do
      user "root"
      cwd "/srv/thecollegesound/current/collegesound/"
      code <<-EOH
      python manage.py migrate main
      EOH
    end
  end
end

# -- Start Service
service "thecollegesound" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :restart => true, :stop=>true
  action [ :stop, :start ]
end