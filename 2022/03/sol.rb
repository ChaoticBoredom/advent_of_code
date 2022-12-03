require_relative "../../aoc_input"

input = get_input(2022, 3).split("\n")

ITEMS = ("a".."z").to_a + ("A".."Z").to_a

def sum_common_items(input)
  input.map do |i|
    f, s = i.chars.each_slice(i.size / 2).to_a
    common = (f & s)
    ITEMS.index(common.first) + 1
  end.sum
end

def sum_badges(input)
  input.each_slice(3).map do |x, y, z|
    common = x.chars & y.chars & z.chars
    ITEMS.index(common.first) + 1
  end.sum
end

puts sum_common_items(input)
puts sum_badges(input)
