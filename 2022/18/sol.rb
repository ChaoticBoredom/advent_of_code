require_relative "../../aoc_input"

input = get_input(2022, 18).chomp.split("\n")

cubes = input.map { |line| line.split(",").map(&:to_i) }

def count_cube_faces(cubes)
  seen = []
  cubes.each do |cube|
    sides = 6
    seen.each.with_index do |s, idx|
      val = 0
      val = -1 if neighbours?(cube, s[0])
      next unless val.negative?

      sides += val
      seen[idx][1] += val
    end

    seen << [cube, sides]
  end

  seen.sum { |_, s| s }
end

def neighbours?(c1, c2)
  return true if (c1[0] - c2[0]).abs == 1 && c1[1] == c2[1] && c1[2] == c2[2]
  return true if (c1[1] - c2[1]).abs == 1 && c1[0] == c2[0] && c1[2] == c2[2]
  return true if (c1[2] - c2[2]).abs == 1 && c1[0] == c2[0] && c1[1] == c2[1]
end

def neighbours(cube, min, max)
  x, y, z = cube
  neighbours = []
  neighbours << [x - 1, y, z] if x > min
  neighbours << [x + 1, y, z] if x < max
  neighbours << [x, y - 1, z] if y > min
  neighbours << [x, y + 1, z] if y < max
  neighbours << [x, y, z - 1] if z > min
  neighbours << [x, y, z + 1] if z < max
  neighbours
end

def count_cube_external_faces(cubes)
  area = 0
  min = cubes.flatten.min - 1
  max = cubes.flatten.max + 1
  edge = [[min] * 3]
  steam = edge.dup
  until edge.empty?
    p = edge.pop
    (neighbours(p, min, max) - steam).each do |c|
      if cubes.include?(c)
        area += 1
      else
        steam << c
        edge << c
      end
    end
  end
  area
end

puts count_cube_faces(cubes)
puts count_cube_external_faces(cubes)
