require_relative "../../aoc_input"

input = get_input(2021, 8).split("\n")

vals = input.map { |i| i.split(" | ").map { |x| x.split(" ") }.map { |x| x.map { |y| y.split("") } } }

easy_nums = 0
vals.each do |_, y|
  y.each do |val|
    easy_nums += 1 if [2, 4, 3, 7].include?(val.count)
  end
end

puts easy_nums

def solve_inputs(input)
  one = input.select { |i| i.count == 2 }.first
  seven = input.select { |i| i.count == 3 }.first
  eight = input.select { |i| i.count == 7 }.first
  four = input.select { |i| i.count == 4 }.first
  twos_threes_fives = input.select { |i| i.count == 5 }
  sixes_nines_zeros = input.select { |i| i.count == 6 }

  two, three, five, six, nine, zero = nil
  two = twos_threes_fives.select { |x| (x - four - seven).size > 1 }.first

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

  {
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
end

def get_outputs(output, numbers)
  value = []
  output.map(&:sort).each { |x| value << numbers[x] }
  value.join.to_i
end

results = []
vals.each do |x, y|
  numbers = solve_inputs(x)
  results << get_outputs(y, numbers)
end

puts results.sum
