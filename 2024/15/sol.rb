require_relative "../../aoc_input"
require "matrix"
require "set"

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
        bot_loc = Vector[x * modifier, y]
        maze_hash[:bot] = bot_loc
        next
      end
      next if c == "."

      modifier.times do |i|
        maze_hash[Vector[x * modifier + i, y]] = [
          c,
          [Vector[x * modifier, y], Vector[x * modifier + (modifier - 1), y]], # Origin and final loc of barrels
        ]
      end
    end
  end
  maze_hash
end

def move_barrels(move_dir, maze, new_loc)
  first_barrel = maze.fetch(new_loc, [])
  return true if first_barrel.empty?

  barrel_list = get_all_barrels(move_dir, maze, new_loc)

  return false if barrel_list.empty?

  barrel_list.map { |b| [b, maze.delete(b).last] }.each do |old_loc, (origin, final)|
    maze[old_loc + move_dir] = ["O", [origin + move_dir, final + move_dir]]
  end

  maze
end

def get_all_barrels(move_dir, maze, first_barrel)
  barrels = Set.new([first_barrel])

  btm = [first_barrel]

  until btm.empty?
    next_loc = btm.shift
    return [] if maze.fetch(next_loc, []).first == "#"
    next unless maze.key?(next_loc)

    square, (origin, end_point) = maze.fetch(next_loc)
    diff = end_point - origin
    vec_step = (diff.zero? ? Vector.zero(2) : diff.normalize).map(&:to_i)
    until origin == (end_point + vec_step)
      next_origin = origin + move_dir
      btm += [next_origin] unless barrels.include?(next_origin)
      barrels += [origin]

      origin += vec_step
    end

    barrels += [next_loc]

    next_loc += move_dir if square == "O"
    btm += [next_loc]
  end

  barrels
end

def move_bot(move_dir, maze)
  bot_loc = maze[:bot]
  new_loc = move_dir + bot_loc

  return maze if maze.fetch(new_loc, []).first == "#"

  barrel_moved = move_barrels(move_dir, maze, new_loc)

  maze[:bot] = new_loc if barrel_moved

  maze
end

def sum_barrels(maze)
  t = maze.map do |k, v|
    next if k == :bot
    next unless v.first == "O" && k == v.last.first

    x = k[0] + k[1] * 100
    x
  end
  t.compact
end

def print_maze(maze)
  min, max = maze.keys.minmax_by { |x| x == :bot ? 1 : x.magnitude }
  bot = maze[:bot]
  (min[1]..max[1]).each do |y|
    (min[0]..max[0]).each do |x|
      vec = Vector[x, y]
      if bot == vec
        print "@"
      else
        print maze.fetch(vec, ["."]).first
      end
    end
    print "\n"
  end
end

path = clean_path(path_input)

maze = build_maze(maze_input)
path.each { |p| maze = move_bot(DIRS[p], maze) }
puts sum_barrels(maze).sum

maze = build_maze(maze_input, 2)
path.each { |p| maze = move_bot(DIRS[p], maze) }
puts sum_barrels(maze).sum
