require_relative "../../aoc_input"

input = get_input(2021, 3).split("\n")

gamma = ""
epsilon = ""
input.map(&:chars).transpose.each do |x|
  vals = x.tally
  gamma += vals.max_by { |_, v| v }.first
  epsilon += vals.min_by { |_, v| v }.first
end

puts gamma.to_i(2) * epsilon.to_i(2)

def filter(input)
  modded = input.dup
  input.first.size.times do |idx|
    vals = modded.map(&:chars).transpose
    matcher = yield vals[idx].tally
    modded.select! { |x| x[idx] == matcher }
    return modded.first if modded.size == 1
  end
  modded.first
end

oxygen = filter(input) do |h|
  h.select { |_, v| v == h.values.max }.max.first
end

co2 = filter(input) do |h|
  h.select { |_, v| v == h.values.min }.min.first
end

puts oxygen.to_i(2) * co2.to_i(2)
