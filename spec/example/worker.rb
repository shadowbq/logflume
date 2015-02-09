#!/usr/bin/env ruby
require "rubygems"
$:.unshift File.join(File.dirname(__FILE__), *%w[. lib])

require "logflume"


flume = Logflume::Flume.new
flume.dir=File.expand_path(File.join(File.dirname(__FILE__), './spec/data/flume'))
flume.glob='*.log'
flume.blocking=true
flume.pipe='/tmp/logflume.conveyor.fifo'
flume.logger = Logger.new(STDOUT)
flume.logger.level = Logger::INFO
flume.start

gets