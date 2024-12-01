require_relative "../../aoc_input"

input = get_input(2024, "1").split("\n")

res = input.map { |x| x.split("   ").map(&:to_i) }

left, right = res.transpose

differences = []

left.sort!
right.sort!
left.each.with_index do |_, i|
  differences << (left[i] - right[i]).abs
end

puts differences.sum

right_tally = right.tally

similarities = []
left.each.with_index do |_, i|
  similarities << (left[i] * right_tally.fetch(left[i], 0))
end

puts similarities.sum
