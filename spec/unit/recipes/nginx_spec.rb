#
# Cookbook Name:: np-web
# Spec:: nginx
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::nginx' do
  before :all do
    common_stubs
    @chef_run = memoized_runner(described_recipe)
  end

  subject { @chef_run }

  it { is_expected.to include_recipe 'nginx' }
end
