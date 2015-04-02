require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Logflume do

  #Standard working test of all fields
  it 'finds files in a directory' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/flume'
    flume.glob='*.log'
    flume.logger = Logger.new('/dev/null')
    expect(flume.start.class.to_s).to eq 'DirectoryWatcher'
    flume.shutdown
  end

  it 'handles fifo pipes' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/flume'
    flume.glob='*.log'
    flume.pipe="/tmp/tmp.flume.#{$$}.fifo"
    flume.logger = Logger.new('/dev/null')
    expect(flume.start.class.to_s).to eq 'DirectoryWatcher'
    flume.shutdown
  end

  it 'prepends syslog when instructed when making a pipe' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/flume'
    flume.glob='*.log'
    flume.pipe="/tmp/tmp.flume.#{$$}.fifo"
    flume.logger = Logger.new('/dev/null')
    flume.prefix_syslog=true
    flume.syslog_progname="dpkg"
    #flume.blocking = true
    expect(flume.start.class.to_s).to eq 'DirectoryWatcher'
    sleep(2) ## We need to ba able to catch PROC errors here..
    flume.shutdown
  end

  it 'should raise an InvalidDirectory Error' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/missingdirectory'
    flume.glob='*.log'
    expect{flume.start}.to raise_error(Logflume::InvalidDirectory)
  end

  it 'should raise an InvalidShiftDirectory Error' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/flume'
    flume.glob='*.log'
    flume.shift='/var/does/not/exist'
    expect{flume.start}.to raise_error(Logflume::InvalidShiftDirectory)
  end

  it 'finds files in a directory' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/flume'
    flume.glob='*.log'
    flume.logger = Logger.new('/dev/null')
    flume.start
    #FileUtils.touch('spec/data/flume/test.log')
    expect(flume.shutdown).to eq true
  end

  describe "shift group" do
    before(:context) do
        require 'fileutils'
        @data = 'spec/data/flume'
        @monitor = '/tmp/flume'
        @shift = '/tmp/flume-shift'
        #Cleanup
        FileUtils.rm_rf @monitor
        FileUtils.rm_rf @shift
    end

    before(:example) do
        #Setup
        FileUtils.cp_r @data, @monitor
        FileUtils.mkdir_p @shift
    end

    it 'handles fifo pipes' do
        flume = Logflume::Flume.new
        flume.dir=@monitor
        flume.glob='*.log'
        flume.pipe="/tmp/tmp.flume.#{$$}.fifo"
        flume.logger = Logger.new('/dev/null')
        flume.prefix_syslog=true
        flume.syslog_progname="dpkg"
        flume.shift = @shift
        #flume.blocking = true
        expect(flume.start.class.to_s).to eq 'DirectoryWatcher'
        sleep(2) ## We need to ba able to catch PROC errors here..
        flume.shutdown
    end

    after(:example) do
        #Cleanup
        FileUtils.rm_rf @monitor
        FileUtils.rm_rf @shift
    end

  end

end
