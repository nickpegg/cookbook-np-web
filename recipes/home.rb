#
# Cookbook Name:: np-web
# Recipe:: home
#
# Copyright (c) 2015 Nick Pegg, All Rights Reserved.

# Sets up www.home.nickpegg.com

# TODO: break this out into its own cookbook maybe?

include_recipe 'apt'
include_recipe 'np-web'

package 'git'
package 'build-essential'
package 'python-dev'
package 'libpq-dev'

app_path = '/srv/web/home.nickpegg.com'
secrets = Chef::EncryptedDataBagItem.load('home', 'secrets')

user 'home' do
  system true
end

# Set up rabbitmq for the celery worker
# TODO: make this a recipe in the np-home cookbook
include_recipe 'rabbitmq'

rabbitmq_vhost '/home'
rabbitmq_user 'home' do
  password secrets['rabbitmq']['password']
  vhost '/home'
  permissions '.* .* .*'
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
      creds: secrets['settings'],
      debug: false
    )
  end

  gunicorn do
    bind "127.0.0.1:#{node[:np_web][:home][:port]}"
  end

  celery_config do
    options do
      broker_url "amqp://home:#{secrets['rabbitmq']['password']}@localhost:5672/home"
    end
  end

  # This is disabled with a poise_service instead since my app doesn't use the
  # new shiny way of using celery
  # celery_worker do
  #   service_name 'home.nickpegg.com-worker'
  # end
end

poise_service 'home-worker' do
  command '/srv/web/home.nickpegg.com/.virtualenv/bin/python manage.py celeryd -l INFO'
  directory app_path
  environment DJANGO_SETTINGS_MODULE: 'home.settings'
  user 'home'
end

# TODO: Set up nginx vhost
