$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require "rubygems"
require "rspec"
#require 'ruby-debug'

require 'simplecov'
SimpleCov.start

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "gravelpile"
require 'pry'


# Require everything in `spec/support`
Dir[File.expand_path('../../spec/support/**/*.rb', __FILE__)].map(&method(:require))

RSpec.configure do |config|

  config.before :each do
    #@spawned_models = []
  end

  config.after :each do
    #@spawned_models.each do |model|
    #  Object.instance_eval { remove_const model } if Object.const_defined?(model)
    #end
  end
end