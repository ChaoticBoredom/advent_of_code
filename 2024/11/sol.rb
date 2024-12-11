require_relative "../../aoc_input"

input = get_input(2024, 11)

stones = input.split(" ").map(&:to_i).tally

def handle_even(stone)
  digits = stone.digits.reverse
  a, b = digits.each_slice(digits.count / 2).to_a
  [a.join.to_i, b.join.to_i]
end

def blink(stones)
  new_hash = Hash.new(0)
  stones.each do |k, v|
    if k.zero?
      new_hash[1] += v
    elsif k.digits.count.even?
      left, right = handle_even(k)
      new_hash[left] += v
      new_hash[right] += v
    else
      new_hash[k * 2024] += v
    end
  end
  new_hash
end

25.times { stones = blink(stones) }

puts stones.values.sum

50.times { stones = blink(stones) }

puts stones.values.sum
