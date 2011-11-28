default[:db][:db_host] = 'localhost'
default[:db][:db_name] = 3306
default[:db][:db_name] = 'collegeplaylists'
default[:db][:db_user] = 'squidiums'
default[:db][:db_pass] = 'Oxw^]H.('

default[:common][:tz_name] = 'America/New York'

default[:thecollegesound][:settings_path]     = '/etc/thecollegesound/settings.py'
default[:thecollegesound][:media_root]        = '/opt/thecollegesound/static/'
default[:thecollegesound][:admin_media]       = '/media/'
default[:thecollegesound][:template_dirs]     = '/opt/thecollegesound/templates/'
default[:thecollegesound][:tmp_path]          = '/tmp/thecollegesound'
default[:thecollegesound][:gunicorn_workers]  = 2
