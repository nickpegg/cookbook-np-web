require 'spec_helper'

describe 'np-web::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe file '/srv/web' do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'www-data' }
  end

  describe file '/srv/web/default/index.html' do
    it { is_expected.to exist }
    it { is_expected.to be_readable.by_user 'www-data' }
  end

  describe file '/etc/nginx/sites-enabled/default' do
    its(:content) { is_expected.to match(/listen\s+80 default_server;/) }
    its(:content) { is_expected.to match(/listen\s+\[::\]:80 default_server;/) }
    its(:content) { is_expected.to match(/listen\s+443 ssl default_server;/) }
    its(:content) { is_expected.to match(/listen\s+\[::\]:443 ssl default_server;/) }
    its(:content) { is_expected.to match %r{ssl_certificate\s+/etc/nginx/ssl/default.crt;} }
    its(:content) { is_expected.to match %r{ssl_certificate_key\s+/etc/nginx/ssl/default.key;} }
    its(:content) { is_expected.to match(/ssl_ciphers\s+"EECDH\+AESGCM:EDH\+AESGCM:AES256\+EECDH:AES256\+EDH";/) }
    its(:content) { is_expected.to match(/ssl_protocols\s+TLSv1 TLSv1.1 TLSv1.2;/) }
    its(:content) { is_expected.to match(/ssl_prefer_server_ciphers\s+on;$/) }
    its(:content) { is_expected.to match %r{root\s+/srv/web/default;$} }
  end

  describe file '/etc/nginx/ssl/default.crt' do
    it { is_expected.to be_owned_by 'www-data' }
    it { is_expected.to be_grouped_into 'www-data' }
    it { is_expected.to be_readable.by_user('www-data') }
  end

  describe x509_certificate '/etc/nginx/ssl/default.crt' do
    it { is_expected.to be_certificate }
  end

  describe file '/etc/nginx/ssl/default.key' do
    it { is_expected.to be_owned_by 'www-data' }
    it { is_expected.to be_grouped_into 'www-data' }
    it { is_expected.to be_readable.by_user('www-data') }
    it { is_expected.to_not be_readable.by('others') }
  end

  describe x509_private_key '/etc/nginx/ssl/default.key' do
    it { is_expected.to_not be_encrypted }
    it { is_expected.to have_matching_certificate '/etc/nginx/ssl/default.crt' }
  end
end
