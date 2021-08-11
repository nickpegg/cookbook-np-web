require 'chefspec'
require 'chefspec/berkshelf'

# Spec helper for np-web
module SpecHelper
  @@runner = {} # rubocop:disable Style/ClassVars

  def common_stubs
    stub_command('which nginx').and_return('/usr/bin/nginx')

    stub_data_bag_item('certificates', 'nginx-default').and_return(
      'cert' => 'some_cert',
      'key' => 'some_key',
    )
  end

  def memoized_runner(recipe)
    @@runner[recipe] ||= begin
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04')
      runner.converge recipe
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelper
end
