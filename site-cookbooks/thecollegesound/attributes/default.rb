#
# Production defaults.
#
default['thecollegesound']['deploy_from_git'] = true
default['thecollegesound']['app_root'] = '/srv/thecollegesound'
default['thecollegesound']['static_root'] = '/opt/thecollegesound'
default['thecollegesound']['config_root'] = '/etc/thecollegesound'

# Django-specific Settings
default['thecollegesound']['debug']        = false
default['thecollegesound']['tz_name']      = 'America/New_York'
default['thecollegesound']['media_root']   = '/srv/thecollegesound/static/'
default['thecollegesound']['admin_media']  = '/admin/media/'
default['thecollegesound']['site_root']    = 'http://thecollegesound.com'
default['thecollegesound']['secret_key']   = 'CHANGEME'

# DB Settings
default['thecollegesound']['db'] = {
    'host' => 'localhost',
    'port' =>  3306,
    'name' => 'thecollegesound',
    'user' => 'tcs_db',
    'pass' => 'CHANGEME'
}

# Datadog
default['thecollegesound']['datadog'] = {
    'api_key' => 'CHANGEME',
    'app_key' => 'CHANGEME'
}

# AWS for SES
default['thecollegesound']['aws'] = {
    'access_key_id' => 'CHANGEME',
    'secret_access_key' => 'CHANGEME'
}

# Email
default['thecollegesound']['admin_email'] = 'admin@thecollegesound.com'
default['thecollegesound']['email'] = {
    'backend' => 'backends.smtp.SSLEmailBackend',
    'host' => 'email-smtp.us-east-1.amazonaws.com',
    'host_user' => 'CHANGEME',
    'host_password' => 'CHANGEME',
    'port' => 465,
}

# Other settings
default['thecollegesound']['gunicorn_workers'] = 5
default['thecollegesound']['user']             = 'thecollegesound'
default['thecollegesound']['tmp_path']         = ''
default['thecollegesound']['bin_path']         = '/usr/local/bin'

# SSH config so we can fetch from Git
default['thecollegesound']['ssh_key'] = nil

# Git SCM settings ($user@$host:$repo)
default['thecollegesound']['git']['user'] = 'git'
default['thecollegesound']['git']['host'] = 'bitbucket.org'
default['thecollegesound']['git']['repo'] = 'conorbranagan/thecollegesound.git'