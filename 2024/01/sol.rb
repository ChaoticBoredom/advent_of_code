require_relative "../../aoc_input"

input = get_input(2024, 1).split("\n").map { |x| x.split(/\s+/).map(&:to_i) }

left, right = input.transpose

def find_differences(left, right)
  left.sort!
  right.sort!

  differences = left.map.with_index { |lv, i| (lv - right[i]).abs }

  differences.sum
end

def find_similarities(left, right)
  right_tally = right.tally

  similarities = left.map { |lv| lv * right_tally.fetch(lv, 0) }

  similarities.sum
end

puts find_differences(left, right)
puts find_similarities(left, right)
