require 'spec_helper'

describe 'np-web::home' do
  describe user 'home' do
    it { is_expected.to exist }
  end

  describe file '/srv/web/home.nickpegg.com' do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'home' }
    it { is_expected.to be_grouped_into 'home' }
  end

  describe file '/srv/web/home.nickpegg.com/.virtualenv' do
    it { is_expected.to be_directory }
  end

  describe service 'home.nickpegg.com' do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe process 'python' do
    it { is_expected.to be_running }
    its(:args) { is_expected.to contain 'unicorn' }
    its(:user) { is_expected.to eq 'home' }
  end

  describe port 8001 do
    it { is_expected.to be_listening.on('127.0.0.1') }
  end
end
