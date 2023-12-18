require_relative "../../aoc_input"

input = get_input(2023, 18).split("\n")

DIRS = {
  "R" => [1, 0],
  "L" => [-1, 0],
  "D" => [0, 1],
  "U" => [0, -1],
}.freeze

HEX_DIRS = {
  "0" => "R",
  "1" => "D",
  "2" => "L",
  "3" => "U",
}.freeze

def part_one_directions(input)
  input.map do |row|
    dir, count, = row.split(" ")
    [dir, count.to_i]
  end
end

def part_two_directions(input)
  input.map do |row|
    _, _, hex = row.split(" ")
    [HEX_DIRS[hex[-2]], hex[2..-3].to_i(16)]
  end
end

def count_borders(directions)
  loc = [0, 0]
  borders = [loc]
  directions.each do |dir, count|
    change = DIRS[dir].map { |v| v * count }
    loc = loc.zip(change).map(&:sum)
    borders << loc
  end
  borders
end

def fill_trench(borders)
  area = 0
  borders.each_cons(2) do |a, b|
    x1, y1 = a
    x2, y2 = b
    area += x1 * y2 - x2 * y1
  end
  area
end

def trench_size(directions)
  borders = count_borders(directions)
  area = fill_trench(borders)
  border_count = directions.sum { |d| d[1] }
  border_count + (area / 2 - border_count / 2 + 1)
end

puts trench_size(part_one_directions(input))
puts trench_size(part_two_directions(input))
