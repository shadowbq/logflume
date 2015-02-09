require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Gravelpile do

#Standard working test of all fields
  it 'finds files in a directory' do
    pile = Gravelpile::Pile.new
    pile.dir='spec/data/pile'
    pile.glob='*.log'
    
    expect(pile.start).to eq 'aaa'
  end

  it 'should raise an InvalidDirectory Error' do
    pile = Gravelpile::Pile.new
    pile.dir='spec/data/pilex'
    pile.glob='*.log'
    expect{pile.start}.to raise_error(Gravelpile::InvalidDirectory)
  end

end