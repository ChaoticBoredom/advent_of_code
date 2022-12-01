require_relative "../../aoc_input"

input = get_input(2015, 2).split("\n")
dims = input.map { |x| x.split("x").map(&:to_i) }

total_paper = dims.map do |l, w, h|
  sides = [l * w, w * h, l * h]
  sides.map { |x| x * 2 }.sum + sides.min
end

total_ribbon = dims.map do |sides|
  sides.min(2).sum * 2 + sides.inject(:*)
end

puts total_paper.sum
puts total_ribbon.sum
