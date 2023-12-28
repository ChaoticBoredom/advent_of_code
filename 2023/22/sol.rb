require_relative "../../aoc_input"
require "set"
require "benchmark"

input = get_input(2023, 22).split("\n")

class Brick
  attr_accessor :cubes, :settled_location

  def initialize(x, y)
    @cubes = [x, y]
    3.times do |i|
      next if x[i] == y[i]

      min, max = [x[i], y[i]].minmax
      ((min + 1)...max).each do |j|
        cube = x.dup
        cube[i] = j
        @cubes << cube
      end
    end
  end

  def drop(other_bricks)
    moved = false
    @settled_location = @cubes
    Kernel.loop do
      new_loc = @settled_location.map { |c| c.zip([0, 0, -1]).map(&:sum) }

      break if new_loc.any? { |c| c[2].zero? }
      break unless (other_bricks & new_loc).empty?

      @settled_location = new_loc
      moved = true
    end
    moved
  end

  def save
    @cubes = @settled_location
  end

  def restore
    @settled_location = @cubes
  end
end

def parse_input(input)
  bricks = []
  input.each do |line|
    brick = line.split("~").map { |x| x.split(",").map(&:to_i) }
    bricks << Brick.new(*brick)
  end
  bricks
end

def drop_bricks(bricks)
  settled = Set.new
  fallen = 0
  bricks.each do |b|
    fallen += 1 if b.drop(settled)
    b.settled_location.each { |l| settled << l }
  end
  fallen
end

def solve(bricks)
  bricks.sort! { |x, y| x.cubes[0][2] <=> y.cubes[0][2] }

  deletable = 0
  total_dropped = 0
  drop_bricks(bricks)
  bricks.map(&:save)

  bricks.each do |b|
    fallen = drop_bricks(bricks.reject { |ib| ib == b })
    bricks.map(&:restore)
    deletable += 1 if fallen.zero?
    total_dropped += fallen
  end
  [deletable, total_dropped]
end

bricks = parse_input(input)

puts solve(bricks)
