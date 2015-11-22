default[:np_web][:base_dir] = '/srv/web'
default[:np_web][:user]     = 'www-data'
default[:np_web][:group]    = 'www-data'

# Array of static sites to set up
default[:np_web][:static_sites] = []

default[:np_web][:home][:repo] = 'https://github.com/nickpegg/home.git'
default[:np_web][:home][:port] = 8001

# nginx cookbook overrides
default['nginx']['default_root'] = ::File.join(node[:np_web][:base_dir], 'default')
