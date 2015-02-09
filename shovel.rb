require 'logger'
require 'directory_watcher'
#gem 'ruby-fifo'
require 'fifo'


@mylog = Logger.new(STDOUT)
@pipe = Fifo.new('./pipe', :w, :wait)

dw = DirectoryWatcher.new('./pile/', :glob => '*.log', :logger => @mylog)
dw.interval = 5.0
#dw.persist = "dw_state.yml"
dw.add_observer  do |*args| 
  args.each do |event| 
    #puts event.inspect
    if event.type == :added
      puts "new File found => #{event.path}"
      root = File.dirname(__FILE__)
      infile = File.join(root, event.path)
      #require 'pry'
      #binding.pry
      puts "infile => #{infile}"
      File.open(infile).each_line do |line| 
        #puts line
        @pipe.puts line
      end
    end
  end
end  

Signal.trap("INT") do
  puts "Terminating..."
  dw.stop
  exit
end

Signal.trap("TERM") do
  puts "Terminating..."
  dw.stop
  exit
end

dw.start  # loads state from dw_state.yml
gets      # when the user hits "enter" the script will terminate
dw.stop   # stores state to dw_state.yml


  