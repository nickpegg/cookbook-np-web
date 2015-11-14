#
# Cookbook Name:: np-web
# Spec:: static_sites
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::static_sites' do
  before do
    common_stubs

    @chef_run = memoized_runner(described_recipe)
    @chef_run.node.set[:np_web][:static_sites] = ['example.com']
    @chef_run.converge(described_recipe)
  end

  subject { @chef_run }

  it { is_expected.to include_recipe 'nginx' }
  it { is_expected.to create_np_web_site 'example.com' }
end
