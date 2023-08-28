module Ip2bin
  class Yield
    # Read lines from SRC and yield it to given block.
    def self.lines(src=STDIN, err=STDERR)
      while line = src.gets
        line.chomp!
        begin
          yield line
        rescue
          err.puts $!, $@
          next
        end
      end
    end
  end
end
