require_relative "../../aoc_input"
require "set"

input = get_input(2024, 23).split("\n").map { |i| i.split("-") }

def build_hash(bhash, comp1, comp2)
  bhash[comp1] += [comp2]
  bhash[comp2] += [comp1]
  bhash
end

def build_connections(input)
  connections = Hash.new(Set.new)
  input.each { |x, y| build_hash(connections, x, y) }
  connections
end

def find_computers_in_groups(connections)
  trios = connections.map { |k, v| v.to_a.combination(2).map { |combo| (combo + [k]).sort } }
  trios.combination(2).map { |x, y| x & y }.flatten(1).uniq
end

def largest_subset(groups)
  group_count = groups.flatten.uniq.map { |x| [x, groups.select { |y| y.include?(x) }.count] }.to_h
  max_val = group_count.values.max
  group_count.select { |_, v| v == max_val }.keys
end

connections = build_connections(input)
groups = find_computers_in_groups(connections)

puts groups.select { |g| g.any? { |c| /^t/.match?(c) } }.count
puts largest_subset(groups).sort.join(",")
