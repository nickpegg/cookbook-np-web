#
# Cookbook Name:: np-web
# Spec:: home
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::home' do
  before do
    common_stubs
    @chef_run = memoized_runner(described_recipe)
  end

  subject { @chef_run }

  it do
    is_expected.to deploy_application('/srv/web/home.nickpegg.com').with(
      # git: 'https://github.com/nickpegg/home'
    )
  end
end
