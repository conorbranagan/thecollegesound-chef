maintainer       "The College Sound"
maintainer_email "admin@thecollegesound.com"
license          "All rights reserved"
description      "Installs/Configures The College Sound web server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "nginx"
depends "mysql"
depends "gunicorn"
