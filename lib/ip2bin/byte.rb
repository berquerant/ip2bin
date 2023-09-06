module Ip2bin
  # An integer between 0 and 256.
  class Byte
    attr_reader :int

    def initialize(int)
      raise Error, "Invalid Byte value: #{int}" if int < 0 or int > 255
      @int = int
    end

    def &(other)
      Byte.new(int & other.int)
    end

    def to_bin
      Bin.new(@int)
    end

    def to_s
      to_bin.to_s
    end
  end

  # Other expression of `Byte`.
  class Bin
    attr_reader :int

    def initialize(int)
      @int = int
    end

    def to_s
      sprintf("%08b", @int)
    end

    def to_byte
      Byte.new(@int)
    end

    def abbrev
      Compress.abbrev(to_s)
    end

    def self.from_str(str)
      full_str = Compress.deabbrev(str, 8)
      self.new(full_str.to_i(2))
    end
  end
end
