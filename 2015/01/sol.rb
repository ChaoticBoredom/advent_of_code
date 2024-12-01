require_relative "../../aoc_input"

input = get_input(2015, 1).split("")

floor = 0
basement = nil

input.each.with_index(1) do |char, idx|
  floor += 1 if char == "("
  floor -= 1 if char == ")"
  basement = idx if floor.negative? && basement.nil?
end

puts floor
puts basement
