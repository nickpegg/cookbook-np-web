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
end
