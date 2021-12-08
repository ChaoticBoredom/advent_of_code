require_relative "../../aoc_input"

input = get_input(2021, 8).split("\n")

uniq_outputs = { 1 => 2, 4 => 4, 7 => 3, 8 => 7 }

vals = input.map { |i| i.split(" | ").map { |x| x.split(" ") } }

easy_nums = 0
vals.each do |_, y|
  y.each do |val|
    easy_nums += 1 if uniq_outputs.values.include?(val.size)
  end
end

puts easy_nums

def solve_inputs(input, output)
  one = input.select { |i| i.size == 2 }.map { |x| x.split("") }.first # Select 1
  seven = input.select { |i| i.size == 3 }.map { |x| x.split("") }.first # Select 7
  eight = input.select { |i| i.size == 7 }.map { |x| x.split("") }.first # Select 8
  four = input.select { |i| i.size == 4 }.map { |x| x.split("") }.first # Select 4
  twos_threes_fives = input.select { |i| i.size == 5 }.map { |x| x.split("") } # Select 2s, 3s, 5s
  sixes_nines_zeros = input.select { |i| i.size == 6 }.map { |x| x.split("") } # Select 6s, 9s, 0s

  two, three, five, six, nine, zero = nil
  twos_threes_fives.each do |x|
    chars = x - four - seven
    two = x if chars.size > 1
  end

  twos_threes_fives.each do |x|
    chars = x - two
    three = x if chars.one?
    five = x if chars.count > 1
  end

  sixes_nines_zeros.each do |x|
    chars = x - five
    if chars.one?
      if (chars - one).empty?
        nine = x
      else
        six = x
      end
    else
      zero = x
    end
  end

  numbers = {
    one.sort => 1,
    two.sort => 2,
    three.sort => 3,
    four.sort => 4,
    five.sort => 5,
    six.sort => 6,
    seven.sort => 7,
    eight.sort => 8,
    nine.sort => 9,
    zero.sort => 0,
  }

  value = []
  output.map { |x| x.split("").sort }.each { |x| value << numbers[x] }
  value.join.to_i
end

results = []
vals.each do |x, y|
  results << solve_inputs(x, y)
end

puts results.sum
