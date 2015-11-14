require 'chefspec'
require 'chefspec/berkshelf'

# Spec helper for np-web
module SpecHelper
  @@runner = {} # rubocop:disable Style/ClassVars

  def stub_enc_data_bag(bag, item, contents = {})
    allow(Chef::EncryptedDataBagItem).to receive(:load).with(bag, item).and_return(contents)
  end

  def common_stubs
    stub_command('which nginx').and_return('/usr/bin/nginx')

    stub_enc_data_bag('home',
                      'secrets',
                      'id' => 'nick',
                      'secret_key' => 'lolsecret',
                      'db' => {
                        'username' => 'home',
                        'password' => 'sekrit'
                      })
  end

  def memoized_runner(recipe)
    @@runner[recipe] ||= begin
      runner = ChefSpec::SoloRunner.new
      runner.converge recipe
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelper
end
