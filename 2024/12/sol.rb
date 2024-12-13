require_relative "../../aoc_input"
require "set"
require "matrix"

input = get_input(2024, 12)

DIRS = {
  "S" => Vector[0, 1],
  "N" => Vector[0, -1],
  "E" => Vector[1, 0],
  "W" => Vector[-1, 0],
}.freeze

MAX_X = input.split("\n").first.chars.count
MAX_Y = input.split("\n").count

def map_plots(input)
  plots = Hash.new([])

  input.split("\n").each_with_index do |row, j|
    row.chars.each_with_index do |c, i|
      plots[c] += [Vector[i, j]]
    end
  end

  plots.values.each.with_object([]) do |v, regions|
    visited = Set.new
    until visited == Set.new(v)
      regions << Set.new
      to_visit = Set.new([(v - visited.to_a).first])
      regions[-1], visited = get_all_adjacent(regions[-1], visited, to_visit, v)
    end
  end
end

def get_all_adjacent(region, visited, to_visit, all_tiles)
  until to_visit.empty?
    loc = to_visit.first

    region << loc

    visited << loc
    to_visit += (Set.new(adjacent_values(loc, all_tiles)) - visited)
    to_visit = to_visit.delete(loc)
  end
  [region, visited]
end

def adjacent_values(loc, all_tiles)
  s = DIRS.values.map { |v| v + loc }
  s & all_tiles
end

def fence_plots(plots)
  plots.map do |locs|
    area = locs.count
    perimeter = yield(locs.to_a)
    area * perimeter
  end
end

def calculate_perimeter(plots)
  plots.map { |x| 4 - adjacent_values(x, plots).count }.sum
end

def calculate_edges(plots)
  diags = DIRS.to_a.combination(2).to_a.map { |a, b| [a[0] + b[0], a[1] + b[1]] }.reject { |x| x.last.zero? }
  all_dirs = diags.to_h.merge(DIRS)
  plots.map { |x| corner_counter(all_dirs.map { |k, v| k if plots.include?(v + x) }.compact) }.sum
end

def corner_counter(surrounding)
  [
    !surrounding.include?("S") && !surrounding.include?("W"),
    !surrounding.include?("N") && !surrounding.include?("W"),
    !surrounding.include?("S") && !surrounding.include?("E"),
    !surrounding.include?("N") && !surrounding.include?("E"),
    surrounding.include?("S") && surrounding.include?("W") && !surrounding.include?("SW"),
    surrounding.include?("N") && surrounding.include?("W") && !surrounding.include?("NW"),
    surrounding.include?("S") && surrounding.include?("E") && !surrounding.include?("SE"),
    surrounding.include?("N") && surrounding.include?("E") && !surrounding.include?("NE"),
  ].count(true)
end

plots = map_plots(input)

puts fence_plots(plots) { |locs| calculate_perimeter(locs) }.sum
puts fence_plots(plots) { |locs| calculate_edges(locs) }.sum
