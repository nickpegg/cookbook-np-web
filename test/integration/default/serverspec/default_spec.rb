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
end
