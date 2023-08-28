require "ip2bin/compress"

RSpec.describe Ip2bin do
  describe "compress" do
    describe "deabbrev" do
      [
        ["", 0, ""],
        ["", 1, ""],
        ["0", 0, "0"],
        ["0", 1, "0"],
        ["0", 2, "00"],
        ["01", 0, "01"],
        ["01", 3, "011"],
      ].each do |str, len, want|
        context "#{str}, #{len}" do
          it "should be #{want}" do
            expect(Ip2bin::Compress.deabbrev(str, len)).to eq(want)
          end
        end
      end
    end
    describe "abbrev" do
      [
        ["", ""],
        ["X", "X"],
        ["1111", "1"],
        ["0111", "01"],
        ["1122", "112"],
        ["1011", "101"],
        ["1234", "1234"],
      ].each do |input, want|
        context input do
          it "should be #{want}" do
            expect(Ip2bin::Compress.abbrev(input)).to eq(want)
          end
        end
      end
    end
  end
end
