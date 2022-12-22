require_relative "../../aoc_input"

map, directions = get_input(2022, 22).chomp.split("\n\n")

map = map.split("\n").map(&:chars)

def find_start(map)
  [map.first.index("."), 0]
end

def find_change(steps, dir)
  x = y = 0
  case dir
  when 0
    x += steps
  when 1
    y += steps
  when 2
    x -= steps
  when 3
    y -= steps
  end
  [x, y]
end

def loop_map_row(map, x, y, diff)
  if diff.negative?
    new_x = map[y].rindex(".")
    return new_x if map[y].rindex("#") < new_x
  else
    new_x = map[y].index(".")
    return new_x if map[y].rindex("#") > new_x
  end
  x
end

def loop_map_col(map, x, y, diff)
  if diff.negative?
    possible = map.count - 1
    possible -= 1 while map[possible][x] == " " || map[possible][x].nil?
  else
    possible = 0
    possible += 1 while map[possible][x] == " " || map[possible][x].nil?
  end
  return possible if map[possible][x] == "."

  y
end

def march(map, vals, steps)
  x, y, dir = vals

  x_change, y_change = find_change(steps, dir)
  x_val = x_change.negative? ? -1 : 1 unless x_change.zero?
  y_val = y_change.negative? ? -1 : 1 unless y_change.zero?

  x_change.abs.times do
    if (x + x_val).negative? || (x + x_val >= map[y].count)
      x = loop_map_row(map, x, y, x_val)
      next
    end
    new_tile = map[y][x + x_val]
    if new_tile == "."
      x += x_val
      next
    end
    break if new_tile == "#"

    x = loop_map_row(map, x, y, x_val) if new_tile == " " || new_tile.nil?
  end

  y_change.abs.times do
    if y + y_val >= map.count || (y + y_val).negative?
      y = loop_map_col(map, x, y, y_val)
      next
    end
    new_tile = map[y + y_val][x]
    if new_tile == "."
      y += y_val
      next
    end
    break if new_tile == "#"

    y = loop_map_col(map, x, y, y_val) if new_tile == " " || new_tile.nil?
  end
  [x, y, dir]
end

def turn(vals, turn)
  x, y, dir = vals

  change = turn == "R" ? 1 : -1
  dir += change
  dir = dir % 4

  [x, y, dir]
end

def follow_directions(map, directions, march_func)
  curr_val = [*find_start(map), 0]

  steps = directions.scan(/\d+/)
  turns = directions.scan(/L|R/).each

  steps.each do |c|
    new_val = method(march_func).call(map, curr_val, c.to_i)

    begin
      new_val = turn(new_val, turns.next)
    rescue StopIteration
    end
    curr_val = new_val
  end

  curr_val
end

MANUAL_CUBE_MAP = {
  "s1" => [0..50, 50..100],
  "s2" => [0..50, 100..150],
  "s3" => [50..100, 50..100],
  "s4" => [100..150, 50..100],
  "s5" => [100..150, 0..50],
  "s6" => [150..200, 0..50],
}.freeze

# dir right = 0, down = 1, left = 2, up = 3

# IF STATEMENTS ARE ALL CUSTOM AND FIGURED OUT W/ PEN + PAPER!!!
def march_cubed(map, curr_val, steps)
  x, y, dir = curr_val

  steps.times do
    new_val = move_place(map, curr_val)
    test_x, test_y, _ = new_val
    break if map[test_y][test_x] == "#"

    curr_val = new_val if map[test_y][test_x] == "."
  end
  curr_val
end

SANITY = true

def move_place(map, curr_val, top_level = true)
  x, y, dir = curr_val
  x_val, y_val = find_change(1, dir)

  new_x = (x + x_val) % map[0].count
  new_y = (y + y_val) % map.count

  if map[new_y][new_x] == " " || map[new_y][new_x].nil?
    if new_x == 49 && new_y.between?(0, 49) && dir == 2 # 1 -> 5
      dir = 0
      new_x = 0
      new_y = 149 - new_y
    elsif new_x == 149 && new_y.between?(100, 149) && dir == 2 # 5 -> 1
      dir = 0
      new_x = 50
      new_y = (new_y - 149).abs
    elsif new_x.between?(50, 99) && new_y == 199 && dir == 3 # 1 -> 6
      dir = 0
      new_y = new_x + 100
      new_x = 0
    elsif new_x == 149 && new_y.between?(150, 199) && dir == 2 # 6 -> 1
      dir = 1
      new_x = new_y - 100
      new_y = 0
    elsif new_x.between?(100, 149) && new_y == 50 && dir == 1 # 2 -> 3
      dir = 2
      new_y = new_x - 50
      new_x = 99
    elsif new_x == 100 && new_y.between?(50, 99) && dir == 0 # 3 -> 2
      dir = 3
      new_x = new_y + 50
      new_y = 49
    elsif new_x == 0 && new_y.between?(0, 49) && dir == 0 # 2 -> 4
      dir = 2
      new_x = 99
      new_y = (new_y - 149).abs
    elsif new_x == 100 && new_y.between?(100, 149) && dir == 0 # 4 -> 2
      dir = 2
      new_x = 149
      new_y = 149 - new_y
    elsif new_x == 49 && new_y.between?(50, 99) && dir == 2 # 3 -> 5
      dir = 1
      new_x = new_y - 50
      new_y = 100
    elsif new_x.between?(0, 49) && new_y == 99 && dir == 3 # 5 -> 3
      dir = 0
      new_y = new_x + 50
      new_x = 50
    elsif new_x.between?(50, 99) && new_y == 150 && dir == 1 # 4 -> 6
      dir = 2
      new_y = new_x + 100
      new_x = 49
    elsif new_x == 50 && new_y.between?(150, 199) && dir == 0 # 6 -> 4
      dir = 3
      new_x = new_y - 100
      new_y = 149
    elsif new_x.between?(0, 49) && new_y == 0 && dir == 1 # 6 -> 2
      new_x += 100
    elsif new_x.between?(100, 149) && new_y == 199 && dir == 3 # 2 -> 6
      new_x -= 100
    end
  end

  if SANITY && top_level
    test_val = [new_x, new_y, (dir + 2) % 4]
    res_val = move_place(map, test_val, false)
    unless res_val[0..1] == curr_val[0..1]
      print [curr_val, test_val, res_val]
      binding.pry
    end
  end

  [new_x, new_y, dir]
end

def calc_password(vals)
  col, row, dir = vals
  (row + 1) * 1000 + (col + 1) * 4 + dir
end

puts calc_password(follow_directions(map, directions, :march))

puts calc_password(follow_directions(map, directions, :march_cubed))
