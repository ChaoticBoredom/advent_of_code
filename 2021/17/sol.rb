require_relative "../../aoc_input"

input = get_input(2021, 17)

def get_target_area(input)
  ranges = /x=(?<x_range>.+), y=(?<y_range>.+)/.match(input)

  [
    Range.new(*ranges["x_range"].split("..").map(&:to_i)),
    Range.new(*ranges["y_range"].split("..").map(&:to_i)),
  ]
end

def move_probe(loc, trajectory)
  loc[0] += trajectory[0]
  loc[1] += trajectory[1]
  trajectory[0] += (trajectory[0].positive? ? -1 : 1) unless trajectory[0].zero?
  trajectory[1] -= 1

  [loc, trajectory]
end

def can_hit?(loc, trajectory, ranges)
  return false if loc[1] < ranges[1].min
  return false if trajectory[0].zero? && !ranges[0].cover?(loc[0])

  true
end

def hit?(loc, ranges)
  return false unless ranges[0].cover?(loc[0])
  return false unless ranges[1].cover?(loc[1])

  true
end

def fire_probe(trajectory, ranges)
  loc = [0, 0]
  max_y = ranges[1].min

  while can_hit?(loc, trajectory, ranges)
    loc, trajectory = move_probe(loc, trajectory)
    max_y = loc[1] if loc[1] > max_y
    return max_y if hit?(loc, ranges)
  end

  nil
end

def find_highest_y(input)
  ranges = get_target_area(input)
  init_trajectory = [ranges[0].max, ranges[1].min]
  max_y = ranges[1].min
  hits = []

  until init_trajectory[0].zero?
    until init_trajectory[1] > ranges[1].min.abs

      max_y_instance = fire_probe(init_trajectory.dup, ranges)
      unless max_y_instance.nil?
        max_y = max_y_instance if max_y < max_y_instance
        hits << init_trajectory.dup
      end
      init_trajectory[1] += 1
    end
    init_trajectory[0] -= 1
    init_trajectory[1] = ranges[1].min
  end

  [max_y, hits]
end

max_y, hits = find_highest_y(input)
puts max_y
puts hits.uniq.count
