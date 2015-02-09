      event_path ='./pile/dpkg.log'

      root = File.dirname(__FILE__)
      infile = File.expand_path(File.join(root, event_path))
      infile = File.join(root, event_path)
      #require 'pry'
      #binding.pry
      puts "infile => #{infile}"
      File.open(infile).each_line do |line| 
        puts line
      end  
