require_relative "../../aoc_input"

input = get_input(2021, 14).split("\n")

template = input.shift

rules = Hash[input.reject(&:empty?).map { |x| x.split(" -> ") }]

def insert_pairs(rules, pairs)
  new_pairs = Hash.new(0)
  pairs.each do |k, v|
    matcher = rules[k]
    new_pairs[k[0] + matcher] += v
    new_pairs[matcher + k[1]] += v
  end
  new_pairs
end

def count_elements(pairs, template)
  total = Hash.new(0)
  pairs.each { |k, v| total[k[0]] += v }
  total[template[-1]] += 1
  total.values.max - total.values.min
end

pairs = Hash.new(0)
template.chars.each_cons(2) { |a, b| pairs[a + b] += 1 }

40.times do |idx|
  pairs = insert_pairs(rules, pairs)
  puts count_elements(pairs, template) if idx == 9
end

puts count_elements(pairs, template)
