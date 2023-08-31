require "ip2bin/byte"

RSpec.describe Ip2bin do
  describe "byte" do
    context "0" do
      it "should be Byte successfully" do
        expect(Ip2bin::Byte.new(0).to_s).to eq("00000000")
      end
    end
    context "1" do
      it "should be Byte successfully" do
        expect(Ip2bin::Byte.new(1).to_s).to eq("00000001")
      end
    end
    context "255" do
      it "should be Byte successfully" do
        expect(Ip2bin::Byte.new(255).to_s).to eq("11111111")
      end
    end
    context "256" do
      it "should raise an error" do
        expect do
          Ip2bin::Byte.new(256)
        end.to raise_error(Ip2bin::Error)
      end
    end
    context "-1" do
      it "should raise an error" do
        expect do
          Ip2bin::Byte.new(-1)
        end.to raise_error(Ip2bin::Error)
      end
    end
  end
end
