require_relative "../../aoc_input"

orig_input = get_input(2015, 10).chomp

def look_and_say(input)
  res = input.chars.chunk { |v| v }.map do |type, chunks|
    [chunks.count, type]
  end

  res.flatten.join
end

input = orig_input.dup
part1 = nil
50.times do |i|
  input = look_and_say(input)
  part1 = input.length if i == 39
end

puts part1
puts input.length
