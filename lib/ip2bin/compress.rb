module Ip2bin
  class Compress
    # Omit the same chars following the end of a string.
    def self.abbrev(str)
      return str if str.length < 2

      start_index = 0
      start_char = ""
      str.chars.each.with_index do |x, i|
        if start_char != x
          start_char = x
          start_index = i
        end
      end
      str[..start_index]
    end

    def self.deabbrev(str, len)
      return str if str.empty? or len <= str.length

      last_char = str[-1]
      str + last_char * (len - str.length)
    end
  end
end
