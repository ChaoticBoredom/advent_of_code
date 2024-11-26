require_relative "../../aoc_input"

input = get_input(2015, 11).chomp

def valid?(input)
  return false unless (input.chars & ["i", "l", "o"]).empty?
  return false unless two_pairs?(input)
  return false unless three_consecutive?(input)

  true
end

def two_pairs?(input)
  input.chars.chunk { |x| x }.to_a.select { |_, count| count.count >= 2 }.map { |type, _| type }.uniq.count >= 2
end

def three_consecutive?(input)
  !input.chars.chunk_while { |x, y| x.succ == y }.select { |x| x.size >= 3 }.empty?
end

input.succ! until valid?(input)

puts input

input.succ!
input.succ! until valid?(input)

puts input
