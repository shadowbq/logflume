require 'logger'
require 'directory_watcher'
#gem 'ruby-fifo'
require 'fifo'

module Gravelpile
  $:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

  #require library
  require 'gravelpile/pile'
  require 'gravelpile/exceptions'
end