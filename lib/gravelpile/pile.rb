module Gravelpile
  class Pile
    attr_accessor :dir, :glob, :logger, :pipe, :pre_load, :interval, :blocking

    def initialize(opts = {})
      @dir = opts[:dir] || './pile/'
      @glob = opts[:glob] || '*.log'
      @logger = opts[:logger] || Logger.new(STDOUT)
      @interval = opts[:interval] || 5.0
      @pre_load = opts[:pre_load] || false
      @blocking = opts[:blocking] || false
      @pipe = opts[:pipe] || "/tmp/gravelpile.pipe.#{$$}"
      @configured = false
    end

    def configured?
      @configured
    end

    def load
      raise InvalidDirectory unless directory_exists?(@dir)
      @dw = DirectoryWatcher.new(@dir, :glob => @glob, :logger => @logger, :interval => @interval, :pre_load => @pre_load)
      @configured = true unless @dw.nil?
      route_pipe
    end

    def start
      load unless configured?
      register_signal_hooks
      @dw.start
    end

    def running?
      @dw.running?
    end

    def stop
      @dw.stop
    end

    def shutdown
      @dw.stop ? @dw.running? : false
      @dw = nil
      @configure = false
      destroy_pipe
      true
    end

    private

    def register_signal_hooks
      [:INT, :QUIT, :TERM].each do |signal|
        ::Signal.trap(signal) do
          puts "Terminating..."
          self.shutdown
          exit
        end
      end
    end

    def route_pipe
      raise PileNotLoaded unless configured?
      create_pipe
      hookup_pipe
    end

    def create_pipe
      if @blocking 
        @pipe_handler = Fifo.new(@pipe, :w, :wait)
      else  
        @pipe_handler = Fifo.new(@pipe)
      end
    end

    def hookup_pipe
      @dw.add_observer  do |*args| 
        args.each do |event| 
          
          if event.type == :added
            root = File.dirname(__FILE__)
            infile = File.join(root, event.path)
            @logger.info "new File found => #{infile}"
            File.open(infile).each_line do |line| 
              @pipe_handler.puts line
            end
          end

        end
      end 
    end

    def directory_exists?(directory)
      File.directory?(directory)
    end

    def destroy_pipe
      FileUtils.rm @pipe, :force => true 
    end

  end
end