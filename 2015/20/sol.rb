require_relative "../../aoc_input"
require "prime"

input = get_input(2015, 20).chomp.to_i

def divisors(input)
  prime_divs = input.prime_division.map { |d| [d[0]] * d[1] }.flatten
  res = (0..prime_divs.count).to_a.flatten.map do |div|
    prime_divs.combination(div).to_a.map { |x| x.inject(1, :*) }.uniq
  end
  res.flatten
end

def infinite_presents_count(check)
  divisors(check).sum * 10
end

def lazy_presents_count(check)
  divisors(check).select { |d| d * 50 >= check }.sum * 11
end

def solve(lower_bound, upper_bound, input, func)
  (lower_bound..upper_bound).each do |x|
    next unless method(func).call(x) >= input

    return x
  end
end

# These bounds may need adjustment depending on input
puts solve(500_000, 1_000_000, input, :infinite_presents_count)
puts solve(500_000, 1_000_000, input, :lazy_presents_count)
