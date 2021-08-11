#
# Copyright:: 2015-2021 Nick Pegg
# Cookbook:: np-web
# Spec:: static_sites
#

require 'spec_helper'

describe 'np-web::static_sites' do
  platform 'ubuntu'
  override_attributes[:np_web][:static_sites] = %w(example.com)

  it { is_expected.to create_np_web_site 'example.com' }
end
