require_relative "../../aoc_input"

input = get_input(2022, 6)

def find_first_marker(input, offset)
  input.chars.each_cons(offset).with_index do |x, idx|
    return idx + offset if x.tally.keys.count == offset
  end
end

puts find_first_marker(input, 4)
puts find_first_marker(input, 14)
