require_relative "../../aoc_input"
require "matrix"

input = get_input(2024, 8)

def parse_input(input)
  max_x = max_y = 0
  antennas = Hash.new([])
  input.split("\n").each.with_index(1) do |line, j|
    max_y = j
    line.chars.each.with_index(1) do |char, i|
      max_x = i
      next if char == "."

      antennas[char] += [Vector[i, j]]
    end
  end

  [antennas, [max_x, max_y]]
end

def calculate_antinodes(antennas, bounds)
  long_nodes = []

  first_nodes = antennas.combination(2).map do |a1, a2|
    dir = a1 - a2

    long_nodes += [a1, a2]
    arr = [a1, a2]

    while arr.any? { |x| in_bounds?(x, bounds) }
      new_points = [arr[0] + dir, arr[1] - dir]
      long_nodes += new_points.select { |x| in_bounds?(x, bounds) }
      arr = new_points
    end

    [a1 + dir, a2 - dir].reject { |x| antennas.include?(x) || !in_bounds?(x, bounds) }
  end
  [first_nodes, long_nodes]
end

def in_bounds?(vec, bounds)
  vec[0].between?(1, bounds[0]) && vec[1].between?(1, bounds[1])
end

antenna_hash, bounds = parse_input(input)

first_antinodes, long_antinodes = antenna_hash.map { |_, v| calculate_antinodes(v, bounds) }.transpose

puts first_antinodes.flatten.uniq.count
puts long_antinodes.flatten.uniq.count
