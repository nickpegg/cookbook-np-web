require 'cookstyle'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: [:berks_update, :cookstyle, :spec]
task all: [:default, :kitchen]

RuboCop::RakeTask.new(:cookstyle) do |task|
  task.options << '--display-cop-names'
end

RSpec::Core::RakeTask.new(:spec)

desc 'Berkshelf update'
task :berks_update do
  sh 'berks update'
end

desc 'Run Kitchen tests'
task :kitchen do
  sh 'kitchen test'
end
