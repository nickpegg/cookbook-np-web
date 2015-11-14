#
# Cookbook Name:: np-web
# Recipe:: home
#
# Copyright (c) 2015 Nick Pegg, All Rights Reserved.

# Sets up www.home.nickpegg.com

package 'git'
package 'build-essential'
package 'python-dev'
package 'libpq-dev'

app_path = '/srv/web/home.nickpegg.com'
secrets = Chef::EncryptedDataBagItem.load('home', 'secrets')

user 'home' do
  system true
end

application app_path do
  git app_path do
    repository node[:np_web][:home][:repo]
    user 'home'
    group 'home'
  end

  owner 'home'
  group 'home'

  python '2.7'
  virtualenv
  pip_requirements

  django do
    secret_key secrets['secret_key']

    database do
      engine    'postgres'
      user      secrets['db']['username']
      password  secrets['db']['password']
      host      'localhost' # TODO: Get database host
      name      'home'
    end

    local_settings_source 'home.settings.erb'
    local_settings_options(
      creds: secrets['settings']
    )
  end

  gunicorn do
    bind "127.0.0.1:#{node[:np_web][:home][:port]}"
  end
end

# TODO: Set up nginx
