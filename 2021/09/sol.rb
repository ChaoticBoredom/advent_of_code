require_relative "../../aoc_input"

input = get_input(2021, 9).split("\n").map { |x| x.split("").map(&:to_i) }

def find_low_points(input)
  low_points = {}
  input.each.with_index do |y, idy|
    y.each.with_index do |x, idx|
      top = input[idy - 1][idx] unless idy.zero?
      bot = input[idy + 1][idx] unless idy >= input.count - 1
      left = input[idy][idx - 1] unless idx.zero?
      right = input[idy][idx + 1] unless idx >= y.count - 1

      next if [top, bot, left, right].include?(x)

      low_points[[idx, idy]] = x if [top, bot, left, right, x].compact.min == x
    end
  end
  low_points
end

low_points = find_low_points(input)

puts low_points.values.map { |x| x + 1 }.sum

def basin?(x, y, val, input)
  return false if x.negative?
  return false if y.negative?
  return false if x >= input[y].count
  return false if y >= input.count

  height = input[y][x]
  height != 9 && val < height
end

def check_dir(loc, val, input, check)
  x, y = loc
  values = []
  x, y = yield x, y
  while check.call(x, y) && basin?(x, y, val, input)
    values << [x, y]
    val = input[y][x]
  end
  values
end

def check_up(loc, val, input)
  check = proc { |_, y| y >= 0 }
  check_dir(loc, val, input, check) { |x, y| [x, y - 1] }
end

def check_left(loc, val, input)
  check = proc { |x, _| x >= 0 }
  check_dir(loc, val, input, check) { |x, y| [x - 1, y] }
end

def check_down(loc, val, input)
  check = proc { |_, y| y < input.count }
  check_dir(loc, val, input, check) { |x, y| [x, y + 1] }
end

def check_right(loc, val, input)
  check = proc { |x, _| x < input.first.count }
  check_dir(loc, val, input, check) { |x, y| [x + 1, y] }
end

def get_basin_size(input, val, point, values, checked_points)
  return checked_points if checked_points.include?(point)

  checked_points << point
  values += check_left(point, val, input)
  values += check_right(point, val, input)
  values += check_up(point, val, input)
  values += check_down(point, val, input)
  values -= checked_points
  values.each do |p|
    checked_points = get_basin_size(input, val, p, values, checked_points)
  end
  checked_points.uniq
end

def find_basins(input, low_points)
  basins = {}
  low_points.each do |loc, val|
    values = get_basin_size(input, val, loc, [loc], [])
    basins[loc] = values.uniq.size
  end
  basins
end

puts find_basins(input, low_points).values.max(3).inject(:*)
