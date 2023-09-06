require "ip2bin/range"
require "ip2bin/ip"

RSpec.describe Ip2bin do
  describe "cidr" do
    context "expand" do
      [
        [
          "192.168.1.0/30",
          [
            "192.168.1.0",
            "192.168.1.1",
            "192.168.1.2",
            "192.168.1.3",
          ],
        ],
      ].each do |input, want|
        context "#{input}" do
          it "should have #{want.length} elements" do
            c = Ip2bin::Cidr.from_str(input)
            got = c.expand.map { |x| x.value.to_s }
            expect(got).to eq(want)
          end
        end
      end
    end

    context "contain" do
      [
        ["192.168.0.0/16", "192.168.1.1", true],
        ["192.168.0.0/16", "192.169.1.18", false],
      ].each do |cidr, target, want|
        context "#{cidr}" do
          it "should be #{want} whether #{target} is contained" do
            c = Ip2bin::Cidr.from_str(cidr)
            ip = Ip2bin::Address.from_str(target)
            expect(c.contain(ip)).to eq(want)
          end
        end
      end
      [
        ["192.168.0.0/16", "192.168.128.0/17", true],
        ["192.168.0.0/16", "192.169.128.0/17", false],
        ["192.168.0.0/16", "192.224.0.0/16", false],
      ].each do |cidr, target, want|
        context "#{cidr}" do
          it "should be #{want} whether #{target} is contained" do
            c = Ip2bin::Cidr.from_str(cidr)
            t = Ip2bin::Cidr.from_str(target)
            expect(c.contain(t)).to eq(want)
          end
        end
      end
    end

    context "network and host" do
      [
        ["0.0.0.0/0", "0.0.0.0", "0.0.0.0"],
        ["192.168.0.0/16", "192.168.0.0", "0.0.0.0"],
        ["192.168.0.1/16", "192.168.0.0", "0.0.0.1"],
      ].each do |input, net, host|
        context "#{input}" do
          it "should have net #{net} and host #{host}" do
            cidr = Ip2bin::Cidr.from_str(input)
            expect(cidr.network.to_s).to eq(net)
            expect(cidr.host.to_s).to eq(host)
          end
        end
      end
    end
  end

  describe "mask" do
    context "string" do
      [
        [0, "0.0.0.0"],
        [8, "255.0.0.0"],
        [10, "255.192.0.0"],
        [16, "255.255.0.0"],
        [24, "255.255.255.0"],
      ].each do |input, want|
        context "#{input}" do
          it "should be #{want}" do
            expect(Ip2bin::Mask.new(input).to_address.to_s).to eq(want)
          end
        end
      end
    end
  end
end
