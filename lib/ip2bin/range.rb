require "ip2bin/ip"

module Ip2bin
  class InvalidCidrError < Error; end

  class Cidr
    attr_reader :address, :mask
    def initialize(address, mask)
      @address = address
      @mask = mask
    end

    def to_s
      "#{@address}/#{@mask.bit}"
    end

    def self.from_str(str)
      # @type var address: String
      address, size = str.split("/")
      self.new(Address.from_str(address), Mask.new(Integer(size)))
    end

    def contain(address_or_cidr)
      case address_or_cidr
      when Address then
        Cidr.new(address_or_cidr, @mask).network.to_s == network.to_s
      when Cidr then
        # @type var t: String
        t = address_or_cidr.network.to_bin[...address_or_cidr.mask.bit]
        # @type var c: String
        c = network.to_bin[...mask.bit]
        t.start_with?(c)
      else
        false
      end
    end

    def host
      @address & ~ @mask.int
    end

    def network
      @address & @mask.int
    end

    def expand
      from = network.to_i
      to = (0xFFFFFFFF & ~@mask.int) | from
      CidrRange.new(Address.from_int(from))..CidrRange.new(Address.from_int(to))
    end
  end

  class CidrGenerator
    include Comparable
    attr_reader :value
    def initialize(value)
      @value = value
    end

    def self.children(cidr, bit)
      from = Cidr.new(cidr.network, Mask.new(cidr.mask.bit + bit))
      d = 1 << (32 - cidr.mask.bit)
      to = Cidr.new(Address.from_int(cidr.network.to_i + d), cidr.mask)
      self.new(from)...self.new(to)
    end

    def <=>(other)
      @value.network.to_i <=> other.value.network.to_i
    end

    def succ
      v = @value.network.to_i
      d = 1 << (32 - @value.mask.bit)
      CidrGenerator.new(Cidr.new(Address.from_int(v + d), @value.mask))
    end
  end

  class CidrRange
    include Comparable
    attr_reader :value
    def initialize(value)
      @value = value
    end

    def <=>(other)
      @value.to_i <=> other.value.to_i
    end

    def succ
      CidrRange.new(Address.from_int(@value.to_i + 1))
    end
  end

  class Mask
    attr_reader :bit, :int
    def initialize(bit)
      @bit = bit
      @int = (0...bit).map{|i| 1 << (31 - i)}.sum
    end

    def to_address
      Address.from_int(@int)
    end
  end
end
