require_relative "../../aoc_input"
require "set"
require "matrix"

input = get_input(2024, 16)

DIRS = {
  "E" => Vector[1, 0],
  "S" => Vector[0, 1],
  "W" => Vector[-1, 0],
  "N" => Vector[0, -1],
}.freeze

DIR_ARR = ["E", "N", "W", "S"].freeze

def parse_input(input)
  maze = {}
  input.split("\n").each.with_index do |line, y|
    line.chars.each.with_index do |c, x|
      maze[Vector[x, y]] = c
    end
  end
  maze
end

def find_paths(maze, start_point, end_point, dir)
  path = {}
  scores = Hash.new(Float::INFINITY)
  scores[[start_point, dir]] = 0

  queue = [[0, start_point, dir]]

  until queue.empty?
    score, position, direction = queue.sort_by!(&:first).shift

    return score, direction, path if position == end_point

    did = DIR_ARR.index(direction)

    [
      [score + 1, position + DIRS[direction], direction],
      [score + 1000, position, DIR_ARR[(did - 1)]],
      [score + 1000, position, DIR_ARR[(did + 1) % 4]],
    ].each do |new_score, new_pos, new_dir|
      next if maze[new_pos] == "#"

      if new_score < scores[[new_pos, new_dir]]
        queue += [[new_score, new_pos, new_dir]]
        path[[new_pos, new_dir]] = [[position, direction]]
        scores[[new_pos, new_dir]] = new_score
      elsif new_score == scores[[new_pos, new_dir]]
        path[[new_pos, new_dir]] << [position, direction]
      end
    end
  end
end

def find_best_seat(path, start_dir, start_point)
  visited = Set.new
  queue = path[[start_point, start_dir]]

  until queue.empty?
    tile = queue.shift
    visited << tile.first
    queue += path.fetch(tile, [])
  end

  visited.size + 1
end

maze = parse_input(input)

score, dir, path = find_paths(maze, maze.key("S"), maze.key("E"), "E")

puts score
puts find_best_seat(path, dir, maze.key("E"))
