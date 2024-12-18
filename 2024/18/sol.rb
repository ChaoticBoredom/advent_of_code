require_relative "../../aoc_input"
require "matrix"
require "set"

DIRS = {
  "S" => Vector[0, 1],
  "N" => Vector[0, -1],
  "E" => Vector[1, 0],
  "W" => Vector[-1, 0],
}.freeze

input = get_input(2024, 18)

bytes = input.split("\n").map { |line| Vector[*line.split(",").map(&:to_i)] }

def find_path(finish, bytes)
  blocked = Set.new(bytes)

  queue = Set.new([[0, Vector[0, 0]]])

  until queue.empty?
    min_val = queue.min_by { |x| [x[0], *x[1]] }
    queue.delete(min_val)
    distance, position = min_val
    return distance if position == finish

    (DIRS.values.map { |v| position + v }.to_set - blocked).each do |loc|
      next unless loc[0].between?(0, finish[0])
      next unless loc[1].between?(0, finish[1])

      queue << [distance + 1, loc]
      blocked << position
    end
  end
end

def find_blocking(bytes)
  finish = Vector[70, 70]
  left = 1024
  right = bytes.count

  while left < right - 1
    mid = (left + right) / 2
    find_path(finish, bytes.first(mid)).nil? ? right = mid : left = mid
  end
  bytes[left].to_a.join(",")
end

puts find_path(Vector[70, 70], bytes.first(1024))
puts find_blocking(bytes)
