require "bundler"
require "rake"
require "rspec/core/rake_task"

task :default => :spec

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |task|
  task.pattern = "spec/**/*_spec.rb"
end
