require_relative "../../aoc_input"

require "digest"

input = get_input(2015, 4).chomp

def find_number(input, zero_count)
  idx = 0
  Kernel.loop do
    output = Digest::MD5.hexdigest(input + idx.to_s)
    return idx if output.chars.first(zero_count).all? { |x| x == "0" }

    idx += 1
  end
end

puts find_number(input, 5)
puts find_number(input, 6)
