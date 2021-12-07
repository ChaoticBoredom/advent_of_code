require_relative "../../aoc_input"

input = get_input(2021, 7).split(",").map(&:to_i).tally

def calc_fuel(input)
  fuel_cost = Hash.new(0)

  input.keys.max.times do |k|
    fuel_used = 0
    input.each_key do |k2|
      fuel = (k - k2).abs
      fuel_used += (yield(fuel) * input[k2])
    end
    fuel_cost[k] = fuel_used
  end

  fuel_cost.min_by { |_, v| v }.last
end

puts calc_fuel(input) { |fuel| fuel }
puts calc_fuel(input) { |fuel| ((fuel + 1) * fuel) / 2 }
