require_relative "../../aoc_input"
require "matrix"

maze_input, path_input = get_input(2024, 15).split(/\n\n/)

DIRS = {
  "v" => Vector[0, 1],
  "^" => Vector[0, -1],
  ">" => Vector[1, 0],
  "<" => Vector[-1, 0],
}.freeze

def clean_path(path)
  path.split("\n").join.chars
end

def build_maze(maze, modifier = 1)
  maze_hash = {}
  boxes = maze.split("\n")
  boxes.each.with_index(0) do |line, y|
    line.chars.each.with_index(0) do |c, x|
      if c == "@"
        bot_loc = Vector[x, y]
        maze_hash[:bot] = bot_loc
        next
      end
      next if c == "."

      modifier.times do |i|
        maze_hash[Vector[x * modifier + i, y]] = [c, Vector[x * modifier, y]]
      end
    end
  end
  maze_hash
end

def move_bot(move_dir, maze, modifier = 1)
  bot_loc = maze[:bot]
  new_loc = move_dir + bot_loc

  return maze if maze.fetch(new_loc, ["."]).first == "#"

  chain_start = new_loc
  new_loc = move_dir + new_loc while maze.fetch(new_loc, ["."]).first == "O"

  return maze if maze.fetch(new_loc, ["."]).first == "#"

  maze[:bot] = chain_start
  csc = maze.delete(chain_start)

  maze[new_loc] = ["O", new_loc] if csc
  maze
end

def sum_barrels(maze)
  t = maze.map do |k, v|
    next if k == :bot
    next unless v.first == "O"

    x = k[0] + k[1] * 100
    x
  end
  t.compact
end

path = clean_path(path_input)

maze = build_maze(maze_input)
path.each { |p| maze = move_bot(DIRS[p], maze) }
puts sum_barrels(maze).sum

maze = build_maze(maze_input, 2)
path.each { |p| maze = move_bot(DIRS[p], maze, 2) }
puts sum_barrels(maze).sum
