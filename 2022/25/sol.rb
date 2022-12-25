require_relative "../../aoc_input"

input = get_input(2022, 25).chomp.split("\n")

VALUES = {
  "0" => 0,
  "1" => 1,
  "2" => 2,
  "-" => -1,
  "=" => -2,
}.freeze

def convert_from_snafu(val)
  total = 0
  val.chars.reverse.each.with_index(1) do |char, idx|
    total += VALUES[char] * (5**idx)
  end

  total
end

def convert_to_snafu(val)
  vals = val.to_s(5).chars.map(&:to_i)
  while vals.any? { |x| x >= 3 }
    vals.dup.each_with_index do |v, idx|
      next if v < 3

      vals[idx - 1] += 1
      vals[idx] -= 5
    end
  end

  vals.map { |v| VALUES.invert[v] }
end

values = input.map { |v| convert_from_snafu(v) }
puts convert_to_snafu(values.sum).join
