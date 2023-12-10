require_relative "../../aoc_input"

input = get_input(2023, 10).split("\n")

DIRS = {
  "N" => [-1, 0],
  "S" => [1, 0],
  "E" => [0, 1],
  "W" => [0, -1],
}.freeze

TILES = {
  "|" => ["N", "S"],
  "-" => ["E", "W"],
  "L" => ["N", "E"],
  "J" => ["N", "W"],
  "7" => ["S", "W"],
  "F" => ["S", "E"],
  "." => [],
  "S" => ["N", "S", "E", "W"],
}.freeze

CONNECTORS = {
  "N" => "S",
  "S" => "N",
  "E" => "W",
  "W" => "E",
}.freeze

def make_map(input)
  @map = Hash.new(".")
  input.each.with_index do |row, i|
    row.each_char.with_index do |char, j|
      @map[[i, j]] = char
    end
  end
end

def find_start(input)
  input.each.with_index do |row, i|
    j = row.index("S")
    return [i, j] unless j.nil?
  end
end

def get_new_coord(coord, dir)
  coord.zip(DIRS[dir]).map(&:sum)
end

def valid?(tile, direction)
  TILES[tile].include?(CONNECTORS[direction])
end

def get_new_directions(tile, direction)
  TILES[tile] - [CONNECTORS[direction]]
end

def traverse(coord, dir, total_length)
  tile = @map[coord]
  return if tile == "S" && total_length.positive?

  @lengths[coord] = total_length unless @lengths.fetch(coord, Float::INFINITY) < total_length
  new_coords = get_new_coord(coord, dir)
  new_dir = get_new_directions(@map[new_coords], dir).first
  [new_coords, new_dir]
end

def part_one(input)
  start = find_start(input)

  coords = start
  directions = get_new_directions("S", nil).select { |d| valid?(@map[get_new_coord(coords, d)], d) }
  directions.each do |dir|
    (0..).each do |i|
      break i if coords == start && i.positive?

      coords, dir = traverse(coords, dir, i)
    end
  end

  @lengths.values.max
end

def replace_unused_pipes(input)
  input.each.with_index do |line, i|
    line.each_char.with_index do |_, j|
      input[i][j] = "." unless @lengths.key?([i, j])
    end
  end
  input
end

def part_two(input)
  replace_unused_pipes(input)

  total = 0
  input.each do |line|
    subbed = line.gsub(/L(-)*7/, "|").gsub(/F(-)*J/, "|").gsub(/F(-)*7/, "").gsub(/L(-)*J/, "")
    inside = false
    subbed.each_char do |c|
      inside = !inside if c == "|"
      total += 1 if c == "." && inside
    end
  end

  total
end

@lengths = {}
make_map(input)

puts part_one(input)
puts part_two(input)
