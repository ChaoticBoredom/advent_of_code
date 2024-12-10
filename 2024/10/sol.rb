require_relative "../../aoc_input"
require "matrix"

input = get_input(2024, 10)

DIRS = {
  "S" => Vector[0, 1],
  "N" => Vector[0, -1],
  "E" => Vector[1, 0],
  "W" => Vector[-1, 0],
}.freeze

PREV_DIR = { "S" => "N", "N" => "S", "E" => "W", "W" => "E" }.freeze

def parse_input(input)
  map = {}
  input.split("\n").each.with_index do |row, j|
    row.chars.each.with_index do |c, i|
      map[Vector[i, j]] = c.to_i
    end
  end
  map
end

def trailhead_endpoints(map, trail, prev_dir)
  loc = trail.last
  return loc if map[loc] == 9

  locs_to_test = DIRS.except(prev_dir).select do |_, change|
    map.key?(loc + change) && (map[loc] + 1) == map[loc + change]
  end

  return nil if locs_to_test.empty?

  locs_to_test.
    map { |dir, next_step| trailhead_endpoints(map, trail + [loc + next_step], PREV_DIR[dir]) }.
    flatten.
    compact
end

map = parse_input(input)
trailheads = map.find_all { |_, v| v.zero? }.map(&:first)
puts trailheads.map { |t| trailhead_endpoints(map, [t], nil) }.map(&:uniq).map(&:count).sum
puts trailheads.map { |t| trailhead_endpoints(map, [t], nil) }.map(&:count).sum
