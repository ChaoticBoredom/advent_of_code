require_relative "../../aoc_input"
require "set"

input = get_input(2024, 6)

DIRS = [
  [0, -1],
  [1, 0],
  [0, 1],
  [-1, 0],
].freeze

MAX_I = input.split("\n").first.chars.count
MAX_J = input.split("\n").count

def map_input(input)
  map = {}
  start = nil
  input.split("\n").each.with_index(1) do |line, j|
    line.chars.each.with_index(1) do |c, i|
      start = [i, j] if c == "^"

      next unless c == "#"

      map[[i, j]] = "#"
    end
  end

  [map, start]
end

def guard_speed_walk(map, loc, track_direction: false)
  visited = Set.new
  DIRS.cycle do |d|
    new_locs = get_new_locs(loc, d)
    valid_locs = new_locs.take_while { |x| !map.key?(x) }
    visits_with_dir = Set.new(valid_locs.map { |l| [l, d] })
    return true if track_direction && visits_with_dir.subset?(visited)

    visited += track_direction ? visits_with_dir : valid_locs
    loc = valid_locs.last

    break if new_locs == valid_locs
  end
  track_direction ? false : visited
end

def get_new_locs(loc, dir)
  if dir[0].zero?
    range = dir[1].negative? ? loc[1].downto(1) : loc[1].upto(MAX_J)
    range.map { |j_val| [loc[0], j_val] }
  else
    range = dir[0].negative? ? loc[0].downto(1) : loc[0].upto(MAX_I)
    range.map { |i_val| [i_val, loc[1]] }
  end
end

def test_obstacles(input, visited)
  map, start = map_input(input)
  obstacle_count = 0

  visited.each do |val|
    next if val == start

    test_map = map.dup
    test_map[val] = "O"
    obstacle_count += 1 if guard_speed_walk(test_map, start, track_direction: true)
  end
  obstacle_count
end

visited = guard_speed_walk(*map_input(input))

puts visited.count
puts test_obstacles(input, visited)
