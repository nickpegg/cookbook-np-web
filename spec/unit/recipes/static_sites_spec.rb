#
# Cookbook Name:: np-web
# Spec:: static_sites
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'np-web::static_sites' do
  override_attributes[:np_web][:static_sites] = %w(example.com)

  it { is_expected.to create_np_web_site 'example.com' }
end
