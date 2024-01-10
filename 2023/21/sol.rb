require_relative "../../aoc_input"
require "set"
require "matrix"

input = get_input(2023, 21).split("\n")

DIRS = [
  [-1, 0],
  [1, 0],
  [0, 1],
  [0, -1],
].freeze

CYCLE = (0...input.count).to_a.cycle(10).to_a.freeze

def build_map(input)
  map = {}
  input.each.with_index do |row, idx|
    row.chars.each.with_index do |c, idy|
      map[[idx, idy]] = (c == "S" ? "." : c)
    end

    next if map.key?("start")
    next unless row.include?("S")

    map["start"] = [idx, row.index(/S/)]
  end

  map
end

def mod_next_square(coords)
  new_x, new_y = coords
  [
    CYCLE[new_x],
    CYCLE[new_y],
  ]
end

def walk_garden(map, steps)
  start = map.delete("start")
  queue = [[start, 0]]
  reachable = Set.new
  visited = Set.new

  until queue.empty?
    square, step_count = queue.shift
    visited_key = [square, step_count]
    next if visited.include?(visited_key)

    visited << visited_key
    reachable << square if step_count == steps
    next unless step_count < steps

    DIRS.each do |dir|
      next_square = square.zip(dir).map(&:sum)
      test_square = map.key?(next_square) ? next_square : mod_next_square(next_square)
      next if map[test_square] == "#"

      queue << [next_square, step_count + 1]
    end
  end

  map["start"] = start
  reachable.count
end

def part_two(map, x)
  x2 = 64 + 1
  n = (26501365 - x2) / x
  p1 = walk_garden(map, x2)
  p2 = walk_garden(map, x2 + x)
  p3 = walk_garden(map, x2 + 2 * x)

  m = Matrix[[0, 0, 1], [1, 1, 1], [4, 2, 1]]
  res = m.inverse * Matrix.column_vector([p1, p2, p3])

  (res[0, 0] * n * n + res[1, 0] * n + res[2, 0]).to_i
end

map = build_map(input)
puts walk_garden(map, 64)
puts part_two(map, input.count)
