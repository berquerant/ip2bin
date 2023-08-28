require "ip2bin/byte"
require "ip2bin/ip"
require "ip2bin/compress"

RSpec.describe Ip2bin do
  describe "address" do
    context "int" do
      [
        "0.0.0.0",
        "127.0.0.1",
        "128.0.0.0",
      ].each do |input|
        context "#{input}" do
          it "should be #{input}" do
            int = Ip2bin::Address.from_str(input).to_i
            expect(Ip2bin::Address.from_int(int).to_i).to eq(int)
          end
        end
      end
    end
    context "abbrev" do
      [
        ["0.0.0.0", "0"],
        ["128.0.0.0", "10"],
        ["128.128.0.0", "1000000010"],
        ["128.0.0.1", "1" + ("0" * 30) + "1"],
      ].each do |input, want|
        context "#{input}" do
          it "should be #{want}" do
            expect(Ip2bin::Address.from_str(input).abbrev).to eq(want)
          end
        end
      end
    end
    context "bin" do
      [
        ["0.0.0.0", "0" * 32],
        ["128.0.0.0", "1" + "0" * 31],
        ["128.128.0.0", "100000001" + "0" * (7 + 16)],
        ["128.0.0.1", "1" + ("0" * 30) + "1"],
      ].each do |input, want|
        context "#{input}" do
          it "should be #{want}" do
            expect(Ip2bin::Address.from_str(input).to_bin).to eq(want)
          end
        end
      end
    end
    context "str" do
      [
        ["0.0.0.0", "0.0.0.0"],
        ["127.0.0.1", "127.0.0.1"],
        ["10.128", "10.128.0.0"],
        ["10.128.", "10.128.0.0"],
      ].each do |input, want|
        context "#{input}" do
          it "should be #{want}" do
            expect(Ip2bin::Address.from_str(input).to_s).to eq(want)
          end
        end
      end
    end
  end
end
