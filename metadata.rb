name 'np-web'
maintainer 'Nick Pegg'
maintainer_email 'nick@nickpegg.com'
license 'all_rights'
description 'Sets up websites that I host'
long_description 'Sets up websites that I host'
version '0.2.2'

depends 'application_python', '~> 4.0.0'
depends 'nginx', '~> 2.7.6'
depends 'nginx_vhost', '~> 0.1.0'
depends 'poise-service', '~> 1.0.2'
depends 'rabbitmq', '~> 4.4.0'

supports 'debian', '~> 8.0'
supports 'ubuntu', '= 14.04'
