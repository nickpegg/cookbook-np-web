name 'np-web'
maintainer 'Nick Pegg'
maintainer_email 'nick@nickpegg.com'
license 'MIT'
description 'Sets up websites that I host'
version '0.2.10'

# Need to upgrade nginx cookbook before we can support 18.x
chef_version '< 18.0'

depends 'nginx', '~> 10.0'

supports 'debian', '~> 11.0'
supports 'ubuntu', '= 20.04'
supports 'ubuntu', '= 22.04'
