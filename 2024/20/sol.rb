require_relative "../../aoc_input"
require "matrix"
require "set"

input = get_input(2024, 20)

DIRS = {
  "S" => Vector[0, 1],
  "N" => Vector[0, -1],
  "E" => Vector[1, 0],
  "W" => Vector[-1, 0],
}.freeze

def parse_map(input)
  map = {}
  input.split("\n").each.with_index do |line, y|
    line.chars.each.with_index do |c, x|
      map[Vector[x, y]] = c
    end
  end
  map
end

def find_path(map)
  start = map.key("S")
  walls = Set.new(map.select { |_, v| v == "#" }.keys)

  visited = Set.new
  step_counts = { start => 0 }

  queue = [start]
  until queue.empty?
    loc = queue.shift
    visited << loc
    steps = step_counts[loc]

    DIRS.each_value do |v|
      new_loc = loc + v
      next if walls.include?(new_loc) || visited.include?(new_loc)

      step_counts[new_loc] = steps + 1
      queue << new_loc
    end
  end
  step_counts
end

def find_cheats(steps, cheat_count)
  cheat_range = (-cheat_count..cheat_count).to_a

  cheats = steps.to_a.map do |loc, step_count|
    cheat_range.repeated_permutation(2).to_a.map do |x, y|
      next if x.zero? && y.zero?
      next if (x.abs + y.abs) > cheat_count

      new_loc = loc + Vector[x, y]
      next unless steps.key?(new_loc)

      steps[new_loc] - (step_count + (x.abs + y.abs))
    end
  end
  cheats.flatten.compact.reject(&:negative?).reject(&:zero?)
end

map = parse_map(input)
steps = find_path(map)

puts find_cheats(steps, 2).select { |x| x >= 100 }.count
puts find_cheats(steps, 20).select { |x| x >= 100 }.count
