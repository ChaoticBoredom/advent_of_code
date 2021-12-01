require_relative "../../aoc_input"

input = get_input(2021, 1).split("\n").map(&:to_i)

def count_increases(data)
  increases = 0
  last = nil
  data.each do |x|
    if last && x > last
      increases += 1
    end
    last = x
  end

  increases
end

puts count_increases(input)

sums = input.map.with_index do |x, idx|
  next unless (idx + 2) < input.size
  x + input[idx + 1] + input[idx + 2]
end

puts count_increases(sums.compact)
