require_relative "../../aoc_input"

input = get_input(2023, 9).split("\n").map { |l| l.split(" ") }

def get_increments(numbers)
  new_array = []
  numbers.each_cons(2) do |x, y|
    new_array << y - x
  end
  new_array
end

def get_next_value(increments)
  increments.reverse!
  increments.first << 0

  increments.each_cons(2) do |x, y|
    y << x.last + y.last
  end
  increments.last.last
end

def get_prev_value(increments)
  increments.reverse!
  increments.first.unshift(0)

  increments.each_cons(2) do |x, y|
    y.unshift(y.first - x.first)
  end

  increments.last.first
end

def solve(input, get_val_method)
  values = []
  input.each do |line|
    increments = []
    increments << line.map(&:to_i)

    increments << get_increments(increments.last) until increments.last.all?(&:zero?)

    values << get_val_method.call(increments)
  end

  values.sum
end

puts solve(input, method(:get_next_value))
puts solve(input, method(:get_prev_value))
