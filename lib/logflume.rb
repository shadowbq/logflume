require 'rubygems'
require 'logger'
require 'fileutils'

# Gem stack
require 'directory_watcher'
require 'fifo'

module Logflume
  $:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

  #require library
  require 'logflume/flume'
  require 'logflume/exceptions'
end