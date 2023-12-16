require_relative "../../aoc_input"
require 'set'

input = get_input(2023, 16).split("\n")

DIRS = {
  "N" => [0, -1],
  "S" => [0, 1],
  "E" => [1, 0],
  "W" => [-1, 0],
}.freeze

REFLECT = {
  "/" => { "N" => "E", "S" => "W", "E" => "N", "W" => "S" },
  "\\" => { "N" => "W", "S" => "E", "E" => "S", "W" => "N" },
  "|" => { "E" => ["N", "S"], "W" => ["N", "S"], "N" => "N", "S" => "S" },
  "-" => { "N" => ["E", "W"], "S" => ["E", "W"], "E" => "E", "W" => "W" },
}.freeze

def make_map(input)
  map = Hash.new(".")
  input.each.with_index do |row, idy|
    row.chars.each.with_index do |c, idx|
      map[[idx, idy]] = c unless c == "."
    end
  end
  map
end

def get_next_loc(loc, dir)
  loc.zip(DIRS[dir]).map(&:sum)
end

def calc_bounds(input)
  @miny = 0
  @maxy = input.count - 1
  @minx = 0
  @maxx = input.first.size - 1
end

def outside_bounds?(loc)
  !loc[0].between?(@minx, @maxx) ||
    !loc[1].between?(@miny, @maxy)
end

def get_new_dir(current, dir)
  return [dir] if current == "."

  [REFLECT[current][dir]].flatten
end

def run_maze(map, queue)
  seen = Set.new
  seen << queue.first
  until queue.empty?
    loc, dir = queue.pop

    current = map[loc]
    get_new_dir(current, dir).each do |d|
      new_loc = get_next_loc(loc, d)
      next if outside_bounds?(new_loc)
      next if seen.include?([new_loc, d])

      seen << [new_loc, d]
      queue << [new_loc, d]
    end
  end
  seen.collect { |x| x[0] }.uniq.count
end

def run_from_each_corner(map)
  val = []

  0.upto(@maxx) do |i|
    val << run_maze(map, [[[i, 0], "S"]])
    val << run_maze(map, [[[i, @maxy], "N"]])
  end

  0.upto(@maxy) do |i|
    val << run_maze(map, [[[0, i], "E"]])
    val << run_maze(map, [[[@maxx, i], "W"]])
  end

  val.max
end

map = make_map(input)
calc_bounds(input)
puts run_maze(map, [[[0, 0], "E"]])

puts run_from_each_corner(map)
