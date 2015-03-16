# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'logflume/version'

Gem::Specification.new do |s|
  s.name = 'logflume'
  s.version = Logflume::VERSION
  s.license = 'MIT'

  s.authors = ["Shadowbq"]
  s.description = "A library to continually dump the contents of new logfiles into a POSIX FIFO pipe"
  s.email = "shadowbq@gmail.com"

  s.files = Dir.glob("{lib}/**/*") + %w(Rakefile README.md LICENSE )
  s.homepage = 'http://github.com/shadowbq/logflume'
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{A library to continually dump the contents of new logfiles into a unix FIFO pipe}
  s.test_files = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'directory_watcher', '~> 1.5.1'
  s.add_dependency 'mkfifo', '0.0.1'
  s.add_dependency 'ruby-fifo', '0.0.1'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'fivemat'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter'
end
