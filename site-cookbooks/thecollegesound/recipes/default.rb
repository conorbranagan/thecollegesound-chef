#
# Recipe to setup The College Sound
# Copyright 2014-2015, The College Sound
#

tcs_static = node['thecollegesound']['static_root']
tcs_app = node['thecollegesound']['app_root']

# -- Cookbook Requirements
include_recipe 'nginx'
include_recipe 'mysql::server'
include_recipe 'mysql::client'
include_recipe 'gunicorn'
include_recipe 'application'

# -- Packages
# xorg: Required for wkhtml2image
# git-core: Required to pull down the repository
[
  'git-core',
  'xorg'
].each do |requirement|
  package requirement do
    action :install
  end
end

# -- User
tcs_user = node['thecollegesound']['user']
user tcs_user do
  supports :manage_home => true
  home "/home/#{tcs_user}"
  shell '/bin/bash'
  action :create
end

# We need a key for git ssh access.
directory "/home/#{tcs_user}/.ssh" do
  owner tcs_user
  mode "0700"
end

file 'private-key' do
  path "/home/#{tcs_user}/.ssh/id_rsa"
  content node['thecollegesound']['ssh_key']
  action :create
  owner tcs_user
  mode "0400"
end

# -- Directories

[
  node['thecollegesound']['app_root'],
  node['thecollegesound']['static_root'],
  node['thecollegesound']['config_root'],
  "#{node['thecollegesound']['app_root']}/shared",
  "#{node['thecollegesound']['static_root']}/static/cache/album",
  "#{node['thecollegesound']['static_root']}/static/show/show_pic",
  "#{node['thecollegesound']['static_root']}/static/dj_img/profile_pic",
  '/tmp/thecollegesound'
].each do |dir|
  directory dir do
    owner tcs_user
    mode '0777' # FIXME!! These permissions are clearly wrong.
    recursive true
  end
end

# -- DB Setup
bash 'create_database' do
  user 'root'
  code <<-EOH
  mysql -u root -p#{node['mysql']['server_root_password']} -e "CREATE DATABASE IF NOT EXISTS #{node['thecollegesound']['db']['name']}"
  EOH
end

bash 'grant_mysql' do
  user 'root'
  code <<-EOH
  mysql -u root -p#{node['mysql']['server_root_password']} -e \
        "GRANT ALL on #{node['thecollegesound']['db']['name']}.* TO '#{node['thecollegesound']['db']['user']}'@'localhost' \
          IDENTIFIED BY '#{node['thecollegesound']['db']['pass']}'"
  EOH
end

# Load the DB from a dump if it exists
#bash 'load_db' do
#  user 'root'
#  code <<-EOH
#  if [ -f /home/#{tcs_user}/tcs_dump.sql ]; then
#      # Load from the dump
#      mysql -u root -p#{node['mysql']['server_root_password']} #{node['thecollegesound']['db']['name']} < /home/#{tcs_user}/tcs_dump.sql
#      # Rename the dump so we don't load it twice
#      mv /home/#{tcs_user}/tcs_dump.sql /home/#{tcs_user}/tcs_dump.sql.old
#  fi
#  EOH
#end


# -- Deploy!

#### Move binary into place
#
# Note: Uncomment for a new install and put the wkhtmltoimage and wkhtmltopdf
# binaries into files/default/ because the upload is SLOW if we push the new
# files every time.
#

#cookbook_file '/usr/local/bin/wkhtmltoimage' do
#  action 'create_if_missing'
#  source 'wkhtmltoimage'
#  mode "0655"
#end

#cookbook_file '/usr/local/bin/wkhtmltopdf' do
#  action 'create_if_missing'
#  source 'wkhtmltopdf'
#  mode "0655"
#end

# -- Do the SCM deploy

# Configure the SSH keys
directory '/tmp/tcsdeploy/.ssh' do
  owner tcs_user
  recursive true
end

cookbook_file '/tmp/tcsdeploy/wrap-ssh4git.sh' do
  source 'wrap-ssh4git.sh'
  owner tcs_user
  mode 00700
end

# Having symlinks and migrations handled separately so we can run these
# with or without a deploy from git
def setup_before_restart
  tcs_static = node['thecollegesound']['static_root']
  tcs_app = File.join(node['thecollegesound']['app_root'], 'current')

  # -- Link statics (css, js, basic images)
  # FIXME: Consolidate the image directories
  ['css', 'js', 'images', 'icons', 'img'].each do |dir|
    link "#{tcs_static}/static/#{dir}" do
      to "#{tcs_app}/collegesound/static/#{dir}"
    end
  end

  # -- Link templates
  link "#{tcs_static}/templates" do
    to "#{tcs_app}/collegesound/templates"
  end

  # -- Install the package
  bash 'install_package' do
    user 'root'
    cwd tcs_app
    code 'python setup.py install'
  end

  # -- Run migration
  bash 'run_migration' do
    user 'root'
    cwd "#{tcs_app}/collegesound"
    code <<-EOH
      python manage.py convert_to_south main
      python manage.py migrate main
    EOH
  end
end

# Deploy from git or just run the setup for development environments.
application 'thecollegesound' do
  rollback_on_error false
  path node['thecollegesound']['app_root']
  owner node['thecollegesound']['user']
  repository 'ssh://git@bitbucket.org/conorbranagan/thecollegesound.git'
  revision 'master'
  symlink_before_migrate ({
    'local_settings.py' => 'local_settings.py'
  })
  migrate true

  django do
    requirements 'requirements/requirements.txt'
    settings_template 'settings.py.erb'
    local_settings_file 'local_settings.py'
    debug node['thecollegesound']['debug']
    settings ({
      # Django
      'debug' => node['thecollegesound']['debug'],
      'tz_name' => node['thecollegesound']['tz_name'],
      'media_root' => node['thecollegesound']['media_root'],
      'admin_media_prefix' => node['thecollegesound']['admin_media'],
      'template_dir' => File.join(tcs_static, 'templates'),
      'tmp_file_path' => node['thecollegesound']['tmp_path'],
      'site_root' => node['thecollegesound']['site_root'],

      # DB
      'db' => node['thecollegesound']['db'],

      # Email
      'admin_email' => node['thecollegesound']['admin_email'],
      'email' => node['thecollegesound']['email'],

      # Datadog
      'datadog' => node['thecollegesound']['datadog'],

      # App settings
      'bin_file_path' => node['thecollegesound']['tmp_path'],
      'django_secret_key' => node['thecollegesound']['secret_key'],

      # AWS
      'aws' => node['thecollegesound']['aws']
    })
  end

  gunicorn do
    app_module :django
  end
end

# -- NginX site
template '/etc/nginx/sites-available/thecollegesound' do
  source 'thecollegesound.nginx.conf.erb'
  user 'root'
  variables(
    'access_log_dir' => node['nginx']['log_dir'],
    'admin_media'    => node['thecollegesound']['admin_media'],
    'static_root'    => node['thecollegesound']['static_root']
  )
end

nginx_site 'thecollegesound' do
  enable true
end
