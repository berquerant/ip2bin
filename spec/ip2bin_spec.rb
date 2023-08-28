require "ip2bin"
RSpec.describe Ip2bin do
  it "has a version number" do
    expect(Ip2bin::VERSION).not_to be nil
  end
end
