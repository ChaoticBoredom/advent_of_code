require_relative "../../aoc_input"

input = get_input(2021, 5).split("\n")

lines = input.map do |x|
  x.split(" -> ").map { |y| y.split(",").map(&:to_i) }
end

def run_horizontal_lines(pt1, pt2, map)
  x_coor = [pt1[0], pt2[0]]
  x_coor.min.upto(x_coor.max).each { |x| map[[x, pt1[1]]] += 1 } if pt1[1] == pt2[1]
end

def run_vertical_lines(pt1, pt2, map)
  y_coor = [pt1[1], pt2[1]]
  y_coor.min.upto(y_coor.max).each { |y| map[[pt1[0], y]] += 1 } if pt1[0] == pt2[0]
end

def run_diagonals(pt1, pt2, map)
  ax, ay = pt1
  bx, by = pt2

  return if ax == bx
  return if ay == by

  xdiff = ax <=> bx
  ydiff = ay <=> by
  map[pt1] += 1
  (ax - bx).abs.times do
    ax -= xdiff
    ay -= ydiff
    map[[ax, ay]] += 1
  end
end

def build_map(lines, include_diagonals)
  map = Hash.new(0)

  lines.each do |a, b|
    run_horizontal_lines(a, b, map)
    run_vertical_lines(a, b, map)

    run_diagonals(a, b, map) if include_diagonals
  end
  map.values.count { |v| v >= 2 }
end

puts build_map(lines, false)
puts build_map(lines, true)
