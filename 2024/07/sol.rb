require_relative "../../aoc_input"

input = get_input(2024, 7)

def parse_input(input)
  input.split("\n").to_h do |l|
    res = l.split(":")
    test_val = res.shift.to_i
    values = res.first.split(" ").map(&:to_i)
    [test_val, values]
  end
end

def valid_test?(key, values)
  return true if values.sum == key
  return true if values.inject(:*) == key

  vc = [values.first]

  values.drop(1).each do |x|
    vc = vc.flat_map { |d| yield d, x }
  end
  vc.include?(key)
end

def solve(nums, &solve_method)
  nums.select { |k, v| valid_test?(k, v, &solve_method) }.keys.sum
end

nums = parse_input(input)

puts solve(nums) { |d, x| [d + x, d * x] }
puts solve(nums) { |d, x| [d + x, d * x, (d.to_s + x.to_s).to_i] }
