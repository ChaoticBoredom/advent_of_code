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
  obstacles = Set.new

  DIRS.cycle do |d|
    new_locs = get_new_locs(loc, d)
    valid_locs = new_locs.take_while { |x| !map.key?(x) }
    obs = [(new_locs - valid_locs).first, d]
    return true if track_direction && obstacles.include?(obs)

    obstacles += [obs]

    visited += valid_locs
    loc = valid_locs.last

    break if new_locs == valid_locs
  end
  track_direction ? false : visited
end

def get_new_locs(loc, dir)
  res = loc.zip(dir).map do |l, d|
    if d.zero?
      [l]
    else
      range = d.negative? ? l.downto(1) : l.upto([MAX_I, MAX_J].max)
      [*range]
    end
  end

  counts = res.map(&:count)
  res.map { |x| x.one? ? x * counts.max : x }.transpose
end

def test_obstacles(input, visited)
  map, start = map_input(input)
  obstacle_count = 0

  visited.each do |val|
    next if val == start

    map[val] = "O"
    obstacle_count += 1 if guard_speed_walk(map, start, track_direction: true)
    map.delete(val)
  end
  obstacle_count
end

visited = guard_speed_walk(*map_input(input))

puts visited.count
puts test_obstacles(input, visited)
