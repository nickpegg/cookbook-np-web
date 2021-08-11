#
# Cookbook Name:: np-web
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::default' do
  before do
    common_stubs
    @chef_run = memoized_runner(described_recipe)
  end

  let(:nginx_dir)     { '/etc/nginx' }
  let(:default_root)  { '/srv/web/default' }

  subject { @chef_run }

  it { is_expected.to install_nginx_install('repo') }

  it 'should create the base directory' do
    is_expected.to create_directory('/srv/web').with(
      owner: 'root',
      group: 'www-data',
      mode: '0775'
    )
  end

  it 'should create the default web root' do
    is_expected.to create_directory(default_root).with(
      owner: 'www-data',
      group: 'www-data',
      mode:  '0755'
    )
  end

  it 'should create the default index.html' do
    is_expected.to create_cookbook_file(::File.join(default_root, 'index.html')).with(
      source: 'default-index.html',
      owner:  'www-data',
      group:  'www-data',
      mode:   '0755'
    )
  end

  it 'should drop the default site cert and key' do
    is_expected.to create_file(::File.join(nginx_dir, 'ssl/default.crt')).with(
      owner:    'www-data',
      group:    'www-data',
      mode:     '0644',
      content:  'some_cert'
    )

    is_expected.to create_file(::File.join(nginx_dir, 'ssl/default.key')).with(
      owner:      'www-data',
      group:      'www-data',
      mode:       '0640',
      content:    'some_key',
      sensitive:  true
    )
  end
end
