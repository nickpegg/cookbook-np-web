#
# Cookbook Name:: np-web
# Spec:: home
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::home' do
  before do
    common_stubs

    stub_enc_data_bag('home',
                      'secrets',
                      'db' => {
                        'username' => 'home',
                        'password' => 'db_password'
                      },
                      'rabbitmq' => { 'password' => 'rabbitmq_secret' })

    @chef_run = memoized_runner(described_recipe)
  end

  subject { @chef_run }

  %w(git build-essential python-dev libpq-dev).each do |pkg|
    it { is_expected.to install_package pkg }
  end

  it { is_expected.to create_user('home').with(system: true) }
  it { is_expected.to include_recipe 'rabbitmq' }
  it { is_expected.to add_rabbitmq_vhost '/home' }

  it do
    is_expected.to add_rabbitmq_user('home').with(
      vhost: '/home',
      permissions: '.* .* .*',
      password: 'rabbitmq_secret'
    )
  end

  it do
    is_expected.to deploy_application('/srv/web/home.nickpegg.com').with(
      owner: 'home',
      group: 'home'
    )
  end

  it do
    is_expected.to enable_poise_service('home-worker').with(
      command: '/srv/web/home.nickpegg.com/.virtualenv/bin/python manage.py celeryd -l INFO',
      user: 'home',
      directory: '/srv/web/home.nickpegg.com',
      environment: { DJANGO_SETTINGS_MODULE: 'home.settings' }
    )
  end
end
