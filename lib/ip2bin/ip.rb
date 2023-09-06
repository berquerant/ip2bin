require "ip2bin/byte"
require "ip2bin/compress"

module Ip2bin
  class InvalidAddressError < Error; end

  # IPv4 address.
  class Address
    attr_reader :bytes

    def initialize(*bytes)
      ary = Array.new(4, Byte.new(0))
      min_len = [ary.length, bytes.length].min
      (0...min_len).map { |i| Integer(i) }.each do |i|
        ary[i] = bytes[i]
      end
      @bytes = ary
    end

    def &(other)
      case other
      when Integer
        Address.from_int(to_i & other)
      when Address
        Address.from_int(to_i & other.to_i)
      else
        raise InvalidAddressError, "Cannot perform Address & #{other.class} (#{other})"
      end
    end

    # Convert the address into the specified format.
    # - `:str`: into string
    # - `:abbrev`: into compressed binary string via `Compress.abbrev`
    # - `:bin`: into binary string
    # - `:int`: into integer
    def to(type = :str)
      case type
      when :str, :s
        to_s
      when :abbrev, :a
        abbrev
      when :bin, :b
        to_bin
      when :int, :i
        to_i
      else
        raise InvalidAddressError, "unknown type #{type}"
      end
    end

    # Return a new `Address` from the value in the specified format.
    # - `:str`: from string
    # - `:int`: from integer
    # - `:bin`: from binary string
    def self.from(str, type = :str)
      case type
      when :str, :s
        self.from_str(str)
      when :int, :i
        self.from_int(Integer(str))
      when :bin, :b
        self.deabbrev(str)
      else
        raise InvalidAddressError, "unknown type #{type}"
      end
    end

    def self.from_str(str)
      self.new(*str.split(".").map { |x| Byte.new(Integer(x)) })
    rescue
      raise InvalidAddressError
    end

    def abbrev
      Compress.abbrev(@bytes.map { |x| x.to_s }.join)
    end

    def self.deabbrev(str)
      self.from_int(Compress.deabbrev(str, 32).to_i(2))
    end

    def to_bin
      @bytes.map { |x| x.to_s }.join
    end

    def to_s
      @bytes.map { |x| x.int }.join(".")
    end

    def to_i
      @bytes.reverse.map.with_index { |x, i| x.int * (1 << (i * 8)) }.sum
    end

    def self.from_int(int)
      mask = 0xFF000000
      v = (0..4).map do |i|
        s = i * 8
        m = mask >> s
        x = int & m
        x >>= 24 - s
        Byte.new(x)
      end
      self.new(*v)
    end
  end
end
