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
    its(:content) { is_expected.to match 'listen 80;' }
    its(:content) { is_expected.to match 'listen \[::\]:80;' }
    its(:content) { is_expected.to match "server_name #{site} www.#{site};$" }
    its(:content) { is_expected.to match "root /srv/web/#{site}/root;$" }
    its(:content) { is_expected.to match "access_log /srv/web/#{site}/logs/#{site}-access.log combined;$" }
    its(:content) { is_expected.to match "error_log  /srv/web/#{site}/logs/#{site}-error.log;$" }
  end
end

# Expect SSL to be set up for example.org since it has a cert data bag item
describe file '/etc/nginx/sites-enabled/example.org' do
  its(:content) { is_expected.to match 'listen 443 ssl;' }
  its(:content) { is_expected.to match 'listen \[::\]:443 ssl;' }
  its(:content) { is_expected.to match 'ssl_certificate     /etc/nginx/ssl/example.org.crt;' }
  its(:content) { is_expected.to match 'ssl_certificate_key /etc/nginx/ssl/example.org.key;' }
  its(:content) { is_expected.to match 'ssl_ciphers "EECDH\+AESGCM:EDH\+AESGCM:AES256\+EECDH:AES256\+EDH";' }
  its(:content) { is_expected.to match 'ssl_protocols TLSv1 TLSv1.1 TLSv1.2;' }
  its(:content) { is_expected.to match 'ssl_prefer_server_ciphers on;$' }
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

describe key_rsa '/etc/nginx/ssl/example.org.key' do
  it { is_expected.to be_private }
end

# We shouldn't have dropped certs for example.com since it doesn't have a databag
describe file '/etc/nginx/ssl/example.com.crt' do
  it { is_expected.to_not exist }
end

describe file '/etc/nginx/ssl/example.com.key' do
  it { is_expected.to_not exist }
end
