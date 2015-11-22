require 'spec_helper'

describe 'np-web::static_sites' do
  describe file '/srv/web' do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
  end

  %w(example.com example.org).each do |site|
    %w(root logs).each do |dir|
      describe file ::File.join('/srv/web', site, dir) do
        it { is_expected.to exist }
        it { is_expected.to be_directory }
        it { is_expected.to be_owned_by 'www-data' }
        it { is_expected.to be_grouped_into 'www-data' }
      end
    end

    describe file ::File.join('/etc/nginx/sites-enabled', site) do
      it { is_expected.to exist }
      it { is_expected.to be_file }
      it { is_expected.to contain 'listen [::]:80;' }
      it { is_expected.to contain "server_name #{site} www.#{site};$" }
      it { is_expected.to contain "root /srv/web/#{site}/root;$" }
      it { is_expected.to contain "access_log /srv/web/#{site}/logs/#{site}-access.log combined;$" }
      it { is_expected.to contain "error_log  /srv/web/#{site}/logs/#{site}-error.log;$" }
    end
  end

  # Expect SSL to be set up for example.org since it has a cert data bag item
  describe file '/etc/nginx/sites-enabled/example.org' do
    it { is_expected.to contain 'listen [::]:443 ssl;' }
    it { is_expected.to contain 'ssl_certificate     /etc/nginx/ssl/example.org.crt;' }
    it { is_expected.to contain 'ssl_certificate_key /etc/nginx/ssl/example.org.key;' }
    it { is_expected.to contain 'ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";' }
    it { is_expected.to contain 'ssl_protocols TLSv1 TLSv1.1 TLSv1.2;' }
    it { is_expected.to contain 'ssl_prefer_server_ciphers on;$' }
  end

  describe file '/etc/nginx/ssl/example.org.crt' do
    it { is_expected.to be_owned_by 'www-data' }
    it { is_expected.to be_grouped_into 'www-data' }
    it { is_expected.to be_readable.by_user('www-data') }
  end

  describe x509_certificate '/etc/nginx/ssl/example.org.crt' do
    it { is_expected.to be_certificate }
  end

  describe file '/etc/nginx/ssl/example.org.key' do
    it { is_expected.to be_owned_by 'www-data' }
    it { is_expected.to be_grouped_into 'www-data' }
    it { is_expected.to be_readable.by_user('www-data') }
    it { is_expected.to_not be_readable.by('others') }
  end

  describe x509_private_key '/etc/nginx/ssl/example.org.key' do
    it { is_expected.to_not be_encrypted }
    it { is_expected.to have_matching_certificate '/etc/nginx/ssl/example.org.crt' }
  end

  # We shouldn't have dropped certs for example.com since it doesn't have a databag
  describe file '/etc/nginx/ssl/example.com.crt' do
    it { is_expected.to_not exist }
  end

  describe file '/etc/nginx/ssl/example.com.key' do
    it { is_expected.to_not exist }
  end
end
