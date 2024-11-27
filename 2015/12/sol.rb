require_relative "../../aoc_input"

input = get_input(2015, 12)

captures = input.scan(/(-?\d+)/)

puts captures.flatten.map(&:to_i).sum

@total = 0

def down_a_level(input)
  return 0 if input.is_a?(Hash) && input.value?("red")

  (input.is_a?(Array) ? input : input.values).each { |v| down_a_level(v) } if input.is_a?(Enumerable)

  @total += input if input.is_a?(Integer)
end

real_input = eval(input)
down_a_level(real_input)
puts @total
