require_relative "../../aoc_input"

input = get_input(2022, 4).split("\n").map { |x| x.split(",") }

def convert_to_range(input)
  input.map do |x, y|
    range1 = x.split("-").map(&:to_i)
    range2 = y.split("-").map(&:to_i)
    r1 = range1[0]..range1[1]
    r2 = range2[0]..range2[1]
    [r1, r2]
  end
end

def count_contained(ranges)
  ranges.sum do |x, y|
    x.cover?(y) || y.cover?(x) ? 1 : 0
  end
end

def count_overlaps(ranges)
  ranges.sum do |x, y|
    x.begin <= y.end && y.begin <= x.end ? 1 : 0
  end
end

ranges = convert_to_range(input)
puts count_contained(ranges)
puts count_overlaps(ranges)
