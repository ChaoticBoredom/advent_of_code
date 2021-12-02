require_relative "../../aoc_input"

input = get_input(2021, 2).split("\n")

forward = 0
depth = 0

input.each do |line|
  dir, count = line.split(" ")
  forward += count.to_i if dir == "forward"
  depth += count.to_i if dir == "down"
  depth -= count.to_i if dir == "up"
end

puts forward * depth

aim = 0
forward = 0
depth = 0
input.each do |line|
  dir, count = line.split(" ")
  aim += count.to_i if dir == "down"
  aim -= count.to_i if dir == "up"
  forward += count.to_i if dir == "forward"
  depth += (aim * count.to_i) if dir == "forward"
end

puts forward * depth
