module Logflume
  class Flume
    attr_accessor :dir, :glob, :logger, :pipe, :pre_load, :interval, :blocking, :prefix_syslog, :syslog_sourceip, :syslog_level, :syslog_facility, :syslog_priority, :syslog_progname, :syslog_severity, :shift, :bookmark

    def initialize(opts = {})
      @dir = opts[:dir] || './flume/'
      @glob = opts[:glob] || '*.log'
      @logger = opts[:logger] || Logger.new(STDOUT)
      @interval = opts[:interval] || 5.0
      @pre_load = opts[:pre_load] || false
      @blocking = opts[:blocking] || false
      @bookmark = opts[:bookmark] || false
      @shift = opts[:shift] || false
      @prefix_syslog = opts[:prefix_syslog] || false
      @syslog_sourceip = opts[:syslog_sourceip] || "127.0.0.1"
      @syslog_facility = opts[:syslog_facility] || "local7"
      @syslog_level = opts[:syslog_level] || "info"
      @syslog_priority = opts[:syslog_priority] || "info"
      @syslog_progname = opts[:syslog_progname] || "logflume"
      @pipe = opts[:pipe] || "/tmp/logflume.pipe.#{$$}"
      @configured = false
    end

    def configured?
      @configured
    end

    def load
      raise InvalidDirectory unless directory_exists?(@dir)
      if @shift
          raise InvalidShiftDirectory unless directory_exists?(@shift)
      end
      @dw = DirectoryWatcher.new(@dir, :glob => @glob, :logger => @logger, :interval => @interval, :pre_load => @pre_load)
      @dw.persist = @bookmark if @bookmark
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
      running? ? stop : true
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
      raise FlumeNotLoaded unless configured?
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
            @logger.info "new File found => #{event.path}"
            if @prefix_syslog
                File.open(event.path).each_line do |line|
                  @pipe_handler.puts prefix + line
                end
            else
                File.open(event.path).each_line do |line|
                  @pipe_handler.puts line
                end
            end
            if @shift
                @logger.info "shift # " + event.path + " -> " + @shift + '/' + File.basename(event.path)
                File.rename(event.path, @shift + '/' + File.basename(event.path))
            end
          end

        end
      end
    end

    def prefix
        mytime = Time.now
        #template("$SOURCEIP|$FACILITY|$PRIORITY|$LEVEL|$TAG|$YEAR-$MONTH-$DAY|$HOUR:$MIN:$SEC|$PROGRAM| $MSG\n")
        #@syslog_priority = @syslog_facility * 8 + @syslog_severity
        ymd = mytime.strftime("%Y-%m-%d")
        hms = mytime.strftime("%H:%M:%S")
        @tag = "logflume"
        return "#{@syslog_sourceip}|#{@syslog_facility}|#{@syslog_priority}|#{@syslog_level}|#{@tag}|#{ymd}|#{hms}|#{@syslog_progname}| "
    end

    def directory_exists?(directory)
      File.directory?(directory)
    end

    def destroy_pipe
      ::FileUtils.rm @pipe, :force => true
    end

    # Borrowed from SyslogLogger.
    def clean(message)
      message = message.to_s.dup
      message.strip! # remove whitespace
      message.gsub!(/\n/, '\\n') # escape newlines
      message.gsub!(/%/, '%%') # syslog(3) freaks on % (printf)
      message.gsub!(/\e\[[^m]*m/, '') # remove useless ansi color codes
      message
    end

  end
end
