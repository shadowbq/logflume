# logflume

[![Gem Version](https://badge.fury.io/rb/logflume.png)](http://badge.fury.io/rb/logflume)
[![Gem](https://img.shields.io/gem/dt/logflume.svg)](http://badge.fury.io/rb/logflume)

A library to continually dump the contents of new logfiles into a POSIX FIFO pipe

## Build Status

[![Build Status](https://travis-ci.org/shadowbq/logflume.svg)](https://travis-ci.org/shadowbq/logflume)
[![Code Climate](https://codeclimate.com/github/shadowbq/logflume/badges/gpa.svg)](https://codeclimate.com/github/shadowbq/logflume) 
[![Test Coverage](https://codeclimate.com/github/shadowbq/logflume/badges/coverage.svg)](https://codeclimate.com/github/shadowbq/logflume)
[![GitHub tag](https://img.shields.io/github/tag/shadowbq/logflume.svg)](http://github.com/shadowbq/logflume)

## FEATURES/PROBLEMS:

A library to continually dump the contents of new logfiles into a POSIX FIFO pipe. This function can mimic what syslog-ng does with FIFO exports. This library is generally dependant on POSIX pipes, so it will not act kindly in Windows ENV.


## INSTALL:

* sudo gem install logflume

## EXAMPLE IMPLEMENTATION:

This is a single blocking logflume. We can call this `worker.rb`. 

You need three posix shells for this to properly work

* Ruby execution shell for `worker.rb`
* A process to `cat '/tmp/logflume.conveyor.fifo'`
* A shell/process to send SIG controls (INT,QUIT,TERM)

### `worker.rb` Source

```ruby
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
```

### Example `worker.rb` Output 

```shell
$ ruby worker.rb 
I, [2015-02-09T00:31:22.389096 #20712]  INFO -- : new File found => /home/shadowbq/sandbox/github-shadowbq/logflume/spec/data/flume/dpkg.log
I, [2015-02-09T00:31:22.395498 #20712]  INFO -- : new File found => /home/shadowbq/sandbox/github-shadowbq/logflume/spec/data/flume/test.log
(.. RCVR SIGQUIT see below ..)
Terminating...
```

### Control Signal Hooks

```shell
$ kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP [..]

$ ps aux |grep ruby
shadowbq 20712  0.4  0.0 262508 14836 pts/0    Sl+  00:30   0:04 ruby worker.rb

$ kill -3 20712
```

## LICENSE:

(The MIT License)
