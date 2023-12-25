require_relative "../../aoc_input"
require "matrix"

input = get_input(2023, 24).split("\n")

hail = {}

input.each do |row|
  loc, vel = row.split("@").map { |x| x.split(", ").map(&:to_i) }
  hail[loc] = vel
end

test_start = 200_000_000_000_000
test_finsh = 400_000_000_000_000

def intersections(hail, bounds_start, bounds_end)
  intersections = []
  hail.keys.combination(2) do |hail_a, hail_b|
    point = intersect(hail_a, hail[hail_a], hail_b, hail[hail_b])
    next if point.nil?

    intersections << point if point.all? { |t| t.between?(bounds_start, bounds_end) }
  end
  intersections
end

def intersect(point_a, vec_a, point_b, vec_b)
  b_a = point_b.zip(point_a).map { |x| x.inject(:-) }
  a_b = point_a.zip(point_b).map { |x| x.inject(:-) }
  cross_a = vec_a[0] * vec_b[1]
  cross_b = vec_b[0] * vec_a[1]
  ta = (vec_b[1].to_f * b_a[0] - vec_b[0] * b_a[1]) / (cross_a - cross_b)
  tb = (vec_a[1].to_f * a_b[0] - vec_a[0] * a_b[1]) / (cross_b - cross_a)
  return if ta.negative? || tb.negative?

  [point_a[0] + vec_a[0] * ta, point_a[1] + vec_a[1] * ta]
end

def get_plane(point_a, vec_a, point_b, vec_b)
  dir = (point_a - point_b).cross(vec_a - vec_b)
  point = (point_a - point_b).dot(vec_a.cross(vec_b))
  [dir, point]
end

def combine(pl1, cross_a, pl2, cross_b, pl3, cross_c)
  x = pl1 * cross_a[0] + pl2 * cross_b[0] + pl3 * cross_c[0]
  y = pl1 * cross_a[1] + pl2 * cross_b[1] + pl3 * cross_c[1]
  z = pl1 * cross_a[2] + pl2 * cross_b[2] + pl3 * cross_c[2]
  Vector[x, y, z]
end

def rock_throw(hail)
  hail_stones = hail.take(3).map { |p, v| [Vector[*p], Vector[*v]] }
  planes = hail_stones.combination(2).map do |hail_a, hail_b|
    get_plane(hail_a[0], hail_a[1], hail_b[0], hail_b[1])
  end

  a, pl1, b, pl2, c, pl3 = planes.flatten
  w = combine(pl1, b.cross(c), pl2, c.cross(a), pl3, a.cross(b))
  t = a.dot(b.cross(c))
  w = Vector[(w[0] / t).to_i, (w[1] / t).to_i, (w[2] / t).to_i]

  w1 = (hail_stones[0][1]) - w
  w2 = hail_stones[1][1] - w
  ww = w1.cross(w2)

  e = ww.dot(hail_stones[1][0].cross(w2))
  f = ww.dot(hail_stones[0][0].cross(w1))
  g = hail_stones[0][0].dot(ww)
  s = ww.dot(ww)

  [combine(e, w1, -f, w2, g, ww), s]
end

puts intersections(hail, test_start, test_finsh).count
results = rock_throw(hail)
puts results[0].sum / results[1]
