require_relative "../../aoc_input"

input = get_input(2022, 14).split("\n")

def build_wall(line, map)
  coords = line.split(" -> ").map { |x| x.split(",").map(&:to_i) }

  coords.each_cons(2) do |x, y|
    dir = x[0] != y[0] ? 0 : 1
    static = dir.zero? ? 1 : 0

    min, max = [x, y].transpose[dir].minmax

    (min..max).each do |new_val|
      new_coords = [nil, nil]
      new_coords[static] = x[static]
      new_coords[dir] = new_val
      map[new_coords] = "#"
    end
  end
end

def pour_sand(cave, max_val, with_floor = false)
  loc = [500, 0]

  Kernel.loop do
    if with_floor && loc[1] + 1 == max_val
      cave[loc] = "o"
      return true
    end

    return false if cave.key?(loc) || loc[1] > max_val

    if !cave.key?([loc[0], loc[1] + 1])
      loc = [loc[0], loc[1] + 1]
    elsif !cave.key?([loc[0] - 1, loc[1] + 1])
      loc = [loc[0] - 1, loc[1] + 1]
    elsif !cave.key?([loc[0] + 1, loc[1] + 1])
      loc = [loc[0] + 1, loc[1] + 1]
    else
      cave[loc] = "o"
      return true
    end
  end
end

map = {}

input.each do |wall|
  build_wall(wall, map)
end

orig_map = map.dup
max_val = map.keys.map(&:last).max

grains = 0
grains += 1 while pour_sand(map, max_val)

puts grains

grains = 0
grains += 1 while pour_sand(orig_map, max_val + 2, true)

puts grains
