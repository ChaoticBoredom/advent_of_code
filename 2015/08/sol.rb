require_relative "../../aoc_input"

input = get_input(2015, 8).split("\n")

total = 0
in_memory = 0

input.each do |line|
  total += line.length
  in_memory += eval(line).length
end

puts total - in_memory

total = 0
expanded = 0

input.each do |line|
  total += line.length
  expanded += line.dump.length
end

puts expanded - total