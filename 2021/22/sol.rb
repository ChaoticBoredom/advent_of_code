require_relative "../../aoc_input"

input = get_input(2021, 22).split("\n")

instructions = input.map do |line|
  dir, ranges = line.split(" ")
  x, y, z = ranges.split(",")
  {
    :dir => dir,
    :x_range => eval(x.split("=")[1]),
    :y_range => eval(y.split("=")[1]),
    :z_range => eval(z.split("=")[1]),
  }
end

reactor = {}

def run_instruction(instruction, reactor)
  dir = instruction[:dir]
  instruction[:x_range].each do |x|
    instruction[:y_range].each do |y|
      instruction[:z_range].each do |z|
        reactor[[x, y, z]] = dir
      end
    end
  end
end

def run_initialization(instruction, reactor)
  init_range = (-50..50)
  return unless init_range.cover?(instruction[:x_range])
  return unless init_range.cover?(instruction[:y_range])
  return unless init_range.cover?(instruction[:z_range])

  run_instruction(instruction, reactor)
end

def intersection(cube1, cube2)
  cube1.zip(cube2).each do |r1, r2|
    return false if r1.min > r2.max || r1.max < r2.min
  end

  cube1.zip(cube2).map { |r1, r2| ([r1.min, r2.min].max..[r1.max, r2.max].min) }
end

def difference(cube1, cube2)
  i = intersection(cube1, cube2)
  return [cube1] unless i

  new_cubes = []
  new_cubes << [cube1[0], cube1[1], (cube1[2].min..i[2].min - 1)]
  new_cubes << [cube1[0], cube1[1], (i[2].max + 1..cube1[2].max)]
  new_cubes << [(cube1[0].min..i[0].min - 1), cube1[1], i[2]]
  new_cubes << [(i[0].max + 1..cube1[0].max), cube1[1], i[2]]
  new_cubes << [i[0], (cube1[1].min..i[1].min - 1), i[2]]
  new_cubes << [i[0], (i[1].max + 1..cube1[1].max), i[2]]

  new_cubes.reject { |x| x.map { |y| y.minmax.compact.empty? }.any? }
end

instructions.each do |i|
  run_initialization(i, reactor)
end

puts reactor.values.tally["on"]

cubes = []
instructions.each do |i|
  cube = [i[:x_range], i[:y_range], i[:z_range]]
  new_cubes = []
  cubes.each { |c| new_cubes += difference(c, cube) }
  new_cubes << cube if i[:dir] == "on"
  cubes = new_cubes
end

puts cubes.map { |x| x.map { |y| y.max - y.min + 1 }.inject(:*) }.sum
