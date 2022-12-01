require_relative "../../aoc_input"

input = get_input(2022, 1).split("\n\n")

elves = input.map { |x| x.split("\n").map(&:to_i).sum }

puts elves.max
puts elves.max(3).sum
