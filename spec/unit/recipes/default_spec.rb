#
# Cookbook Name:: np-web
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::default' do
  before :all do
    common_stubs
    @chef_run = memoized_runner(described_recipe)
  end

  subject { @chef_run }

  it { is_expected.to include_recipe 'np-web::nginx' }

  it 'should create the base directory' do
    is_expected.to create_directory('/srv/web').with(
      owner: 'root',
      group: 'www-data',
      mode: '0775'
    )
  end
end
