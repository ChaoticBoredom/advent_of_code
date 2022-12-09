require "matrix"
require_relative "../../aoc_input"

input = get_input(2022, 9).split("\n")

DIR_HASH = {
  "L" => [-1, 0],
  "R" => [1, 0],
  "U" => [0, -1],
  "D" => [0, 1],
}.freeze

def touching?(curr)
  (Vector[*curr[0]] - Vector[*curr[1]]).magnitude <= 1.4143
end

def move_tail(curr)
  return curr if touching?(curr)

  diff = curr.transpose.map { |x| x.reduce(:-) }.map { |x| x.nonzero? ? (x / x.abs) : x }

  curr[1] = [curr[1], diff].transpose.map { |x| x.reduce(:+) }
  curr
end

def move_rope(tails, dir, rope)
  dir, count = dir.split(" ")
  count = count.to_i
  count.times do
    rope[0] = [rope[0], DIR_HASH[dir]].transpose.map { |x| x.reduce(:+) }
    rope.each_cons(2).with_index do |curr, idx|
      curr = move_tail(curr)
      rope[idx + 1] = curr[1]
    end
    tails[rope.last] += 1
  end
end

def run_bridge(rope, input)
  tails = Hash.new(0)
  tails[[0, 0]] += 1
  input.each do |dir|
    move_rope(tails, dir, rope)
  end
  tails.keys.count
end

puts run_bridge(([] << [0, 0]) * 2, input)
puts run_bridge(([] << [0, 0]) * 10, input)
