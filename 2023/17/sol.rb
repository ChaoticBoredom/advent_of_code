require_relative "../../aoc_input"
require "set"

DIRS = {
  "W" => [1, 0],
  "E" => [-1, 0],
  "N" => [0, -1],
  "S" => [0, 1],
  nil => [],
}.freeze

input = get_input(2023, 17).split("\n")

def build_map(input)
  map = {}

  input.each.with_index do |row, idy|
    row.chars.each.with_index do |c, idx|
      map[[idx, idy]] = c.to_i
    end
  end

  map
end

def end_point(input)
  [input.first.size - 1, input.count - 1]
end

def run_path(map, min_dist, max_dist, end_point)
  queue = [[0, [0, 0], nil]]
  seen = Set.new
  costs = Hash.new(Float::INFINITY)

  until queue.empty?
    cost, loc, dir = queue.delete(queue.min)
    return cost if loc == end_point

    seen_key = [loc, dir]
    next if seen.include?(seen_key)

    seen << seen_key
    DIRS.each do |new_dir, change|
      next if DIRS[dir].map(&:abs) == change.map(&:abs)

      cost_change = 0
      1.upto(max_dist) do |distance|
        new_loc = change.map { |x| x * distance }.zip(loc).map(&:sum)
        next unless map.key?(new_loc)

        cost_change += map[new_loc]
        next if distance < min_dist

        new_cost = cost + cost_change
        costs_key = [new_loc, new_dir]
        next if costs[costs_key] < new_cost

        costs[costs_key] = new_cost
        queue << [new_cost, new_loc, new_dir]
      end
    end
  end
end

map = build_map(input)
end_point = end_point(input)

puts run_path(map, 1, 3, end_point)
puts run_path(map, 4, 10, end_point)
