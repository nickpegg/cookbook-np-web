require 'spec_helper'

describe 'np-web::static_sites' do
  describe file '/srv/web' do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'root' }
    it { is_expected.to be_grouped_into 'www-data' }
  end

  %w(root logs).each do |dir|
    describe file ::File.join('/srv/web/example.com', dir) do
      it { is_expected.to exist }
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'www-data' }
      it { is_expected.to be_grouped_into 'www-data' }
    end
  end

  describe file '/etc/nginx/sites-enabled/example.com' do
    it { is_expected.to exist }
    it { is_expected.to be_file }
    it { is_expected.to contain 'server_name example.com;$' }
    it { is_expected.to contain 'root /srv/web/example.com/root;$' }
    it { is_expected.to contain 'access_log /srv/web/example.com/logs/example.com-access.log combined;$' }
    it { is_expected.to contain 'error_log  /srv/web/example.com/logs/example.com-error.log;$' }
  end
end
