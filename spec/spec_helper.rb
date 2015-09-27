require 'chefspec'
require 'chefspec/berkshelf'

module SpecHelper
  def common_stubs
    stub_command("which nginx").and_return('/usr/bin/nginx')
  end

  def memoized_runner(recipe)
    @runner ||= begin
      runner = ChefSpec::ServerRunner.new
      runner.converge recipe
    end
  end
end

RSpec.configure do |config|
  config.include SpecHelper
end
