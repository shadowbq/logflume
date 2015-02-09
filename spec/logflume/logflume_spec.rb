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

  it 'should raise an InvalidDirectory Error' do
    flume = Logflume::Flume.new
    flume.dir='spec/data/flumex'
    flume.glob='*.log'
    expect{flume.start}.to raise_error(Logflume::InvalidDirectory)
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

end