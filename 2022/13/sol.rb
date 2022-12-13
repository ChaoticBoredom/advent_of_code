require_relative "../../aoc_input"

input = get_input(2022, 13).split("\n\n").map { |x| x.split("\n") }

def in_order?(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    return if left == right

    return left < right
  end

  if left.is_a?(Array) && right.is_a?(Array)
    left.zip(right).each do |l, r|
      return false if r.nil?

      comp = in_order?(l, r)
      return comp unless comp.nil?
    end
    return in_order?(left.count, right.count)
  end

  return in_order?([left], right) if left.is_a?(Integer)

  in_order?(left, [right])
end

right_order = []
input.each.with_index(1) do |vals, idx|
  l = eval(vals[0])
  r = eval(vals[1])
  right_order << idx if in_order?(l, r)
end

packets = input.flatten(1)
indices = [1, 2]
packets.each do |val|
  v = eval(val)
  indices[0] += 1 if in_order?(v, [[2]])
  indices[1] += 1 if in_order?(v, [[6]])
end

puts right_order.sum
puts indices.inject(:*)
