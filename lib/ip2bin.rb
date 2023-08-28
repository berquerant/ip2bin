require "ip2bin/error"
require "ip2bin/version"
require "ip2bin/ip"
require "ip2bin/range"
require "ip2bin/proc"
require "thor"

module Ip2bin
  class App < Thor
    package_name "ip2bin"
    map "c" => "conv",
        "in" => "contain",
        "cc" => "children",
        "m" => "mask"

    desc "mask BIT", "display mask"
    def mask(bit)
      puts Mask.new(Integer(bit)).to_address
    end

    desc "children CIDR BIT", "display cidr children"
    def children(cidr, bit)
      cidr = Cidr.from_str(cidr)
      bit = Integer(bit)
      g = CidrGenerator.children(cidr, bit)
      g.each do |v|
        puts v.value
      end
    end

    option :all, :type => :boolean, :aliases => :a
    desc "expand", "expand cidr"
    def expand
      Yield.lines do |line|
        cidr = Cidr.from_str(line)
        r = cidr.expand
        if options[:all] then
        r.each do |v|
          puts v.value
        end
        else
          puts r.begin.value
          puts r.end.value
        end
      end
    end

    desc "contain CIDR", "determine cidr contain addresses"
    def contain(cidr)
      cidr = Cidr.from_str(cidr)

      Yield.lines do |line|
        target = line.include?("/") ? Cidr.from_str(line) : Address.from_str(line)
        contained = cidr.contain(target) ? 1 : 0
        puts "#{cidr} #{target} #{contained}"
      end
    end

    option :from, :type => :string, :aliases => :f, :default => :str, :desc => "from format"
    desc "conv TO [options]", "convert address format to TO"
    long_desc <<-LONGDESC
    `ip2bin conv` converts ip address format.

    You can optionally specify a 1st parameter as the format to convert to, followings are valid values:

    bin, b: binary, e.g. 11000000101010000000000100000100
    dec, d, str, s: string, e.g. 192.168.1.4
    int, i: integer, e.g. 3232235780
    abbrev, a: abbreviated binary address, e.g. 00001010 (00001010000000000000000000000000)
    LONGDESC
    def conv(to="bin")
      from = options[:from].to_sym
      to = case to
           when "bin", "b" then :bin
           when "dec", "d", "str", "s" then :str
           when "int", "i" then :int
           when "abbrev", "a" then :abbrev
           else :bin
           end

      Yield.lines do |line|
        puts Address.from(line, from).to(to)
      end
    end

    desc "version", "version"
    def version
      puts VERSION
    end
  end

  App.start
end
