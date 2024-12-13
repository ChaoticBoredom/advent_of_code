require_relative "../../aoc_input"
require "matrix"

input = get_input(2024, 13)

def parse_input(input)
  full_data = []
  input.split("\n").each_slice(4) do |a, b, p, _|
    a_button = /X\+(\d+), Y\+(\d+)/.match(a).captures.map(&:to_i)
    b_button = /X\+(\d+), Y\+(\d+)/.match(b).captures.map(&:to_i)
    prize_loc = /X=(\d+), Y=(\d+)/.match(p).captures.map(&:to_i)
    full_data << [a_button, b_button, prize_loc]
  end
  full_data
end

def min_tokens_for_prize(a_button, b_button, prize_loc)
  return nil if a_button[0] > prize_loc[0] && b_button[0] > prize_loc[0]
  return nil if a_button[1] > prize_loc[1] && b_button[1] > prize_loc[1]

  ab_det = Matrix[a_button, b_button].determinant
  prizeb_det = Matrix[prize_loc, b_button].determinant
  m = prizeb_det / ab_det

  return nil if m * ab_det != prizeb_det

  v = (prize_loc[1] - a_button[1] * m)

  n = v / b_button[1]
  return nil if n * b_button[1] != v

  3 * m + n
end

data_set = parse_input(input)

puts data_set.map { |x| min_tokens_for_prize(*x) }.compact.sum

data_set = data_set.map { |x| [x[0], x[1], x[2].map { |y| y + 10_000_000_000_000 }] }
puts data_set.map { |x| min_tokens_for_prize(*x) }.compact.sum
