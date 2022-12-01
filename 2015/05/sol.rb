require_relative "../../aoc_input"

input = get_input(2015, 5).split("\n")

def contains_three_vowels(input)
  input.scan(/[aeiou]/).size >= 3
end

def contains_double(input)
  input.squeeze.size < input.size
end

def contains_bad_strings(input)
  /ab|cd|pq|xy/ =~ input
end

def nice?(input)
  contains_three_vowels(input) &&
    contains_double(input) &&
    !contains_bad_strings(input)
end

count = 0
input.each do |i|
  count += 1 if nice?(i)
end

puts count

def contains_pair?(input)
  input.chars.each_cons(2).with_index do |x, idx|
    return true unless input[idx + 2, input.size].scan(x.join).empty?
  end
end

def contains_mirror?(input)
  input.chars.each_cons(3) do |x|
    return true if x[0] == x[2]
  end
end

def better_nice?(input)
  contains_pair?(input) &&
    contains_mirror?(input)
end

count = 0
input.each do |i|
  count += 1 if better_nice?(i)
end

puts count
