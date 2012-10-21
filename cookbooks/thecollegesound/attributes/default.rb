# Django-specific Settings
default[:thecollegesound][:debug]             = 'False'
default[:thecollegesound][:tz_name]           = 'America/New_York'
default[:thecollegesound][:media_root]        = '/srv/thecollegesound/static/'
default[:thecollegesound][:admin_media]       = '/admin/media/'
default[:thecollegesound][:template_dir]      = '/srv/thecollegesound/templates/'
default[:thecollegesound][:site_root]         = 'http://thecollegesound.com'
default[:thecollegesound][:secret_key]        = 'CHANGEME'

# DB Settings
default[:thecollegesound][:db] = {
    :host => 'localhost',
    :port =>  3306,
    :name => 'thecollegesound',
    :user => 'tcs_db',
    :pass => 'CHANGEME'
}

# Datadog
default[:thecollegesound][:datadog] = {
    :api_key => 'CHANGEME',
    :app_key => 'CHANGEME'
}

# AWS
default[:thecollegesound][:aws] = {
    :access_key_id => 'CHANGEME',
    :secret_access_key => 'CHANGEME'
}

# Email
default[:thecollegesound][:admin_email] = 'admin@thecollegesound.com'
default[:thecollegesound][:email] = {
    :backend => 'backends.smtp.SSLEmailBackend',
    :host => 'email-smtp.us-east-1.amazonaws.com',
    :host_user => 'CHANGEME',
    :host_password => 'CHANGEME',
    :port => 465,
}

# Other settings
default[:thecollegesound][:gunicorn_workers]  = 5
default[:thecollegesound][:owner_uid]         = 'thecollegesound'
default[:thecollegesound][:settings_path]     = '/srv/thecollegesound/current/collegesound/'
default[:thecollegesound][:tmp_path]          = ''
default[:thecollegesound][:bin_path]          = '/usr/local/bin'
