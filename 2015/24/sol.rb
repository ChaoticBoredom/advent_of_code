require_relative "../../aoc_input"

input = get_input(2015, 24).split("\n").map(&:to_i)

def find_groups(input, groups)
  return input if groups == 1

  weight = input.sum / groups
  options = (1..(input.count - groups)).lazy.map do |count|
    input.combination(count).reduce([]) do |arr, combo|
      next arr if combo.sum != weight
      next arr unless find_groups(input - combo, groups - 1)

      arr + [combo]
    end
  end
  options.find { |x| !x.empty? }
end

puts find_groups(input, 3).map { |x| x.inject(:*) }.min
puts find_groups(input, 4).map { |x| x.inject(:*) }.min
