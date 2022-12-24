require_relative "../../aoc_input"

input = get_input(2022, 23).chomp.split("\n")

input = input.map(&:chars)

FULL_DIRECTIONS = {
  "N" => [[0, -1], [1, -1], [-1, -1]],
  "S" => [[0, 1], [1, 1], [-1, 1]],
  "W" => [[-1, 0], [-1, 1], [-1, -1]],
  "E" => [[1, 0], [1, 1], [1, -1]],
}.freeze

def add_arrays(arr1, arr2)
  [arr1, arr2].transpose.map { |v| v.inject(&:+) }
end

class Elf
  attr_accessor :loc, :next_loc, :moved

  def initialize(x, y)
    @loc = [x, y]
  end

  def propose_move(elves, directions)
    return unless adjacent_elves?(elves)

    directions.each do |dir|
      break if @next_loc

      checks = FULL_DIRECTIONS[dir]
      move_blocked = checks.map { |test| elves.key?(add_arrays(@loc, test)) }.any?
      @next_loc = add_arrays(@loc, checks[0]) unless move_blocked
    end
  end

  def adjacent_elves?(elves)
    FULL_DIRECTIONS.values.flatten(1).uniq.map { |dir| elves.key?(add_arrays(@loc, dir)) }.any?
  end

  def move(moves)
    return if moves.key?(@next_loc)

    @loc = @next_loc
    @moved = true
  end

  def clear_next
    @next_loc = nil
    @moved = false
  end
end

def get_elves(map)
  elves = {}
  map.each_with_index do |line, idy|
    line.each_with_index do |c, idx|
      elves[[idx, idy]] = Elf.new(idx, idy) if c == "#"
    end
  end
  elves
end

def run_round(elves, directions)
  elves.each { |_, e| e.propose_move(elves, directions) }
  moves = elves.each_value.group_by(&:next_loc).select { |_, v| v.count > 1 }
  elves.each { |_, e| e.move(moves) }
  elves_moved = elves.values.map(&:moved).any?
  elves.each_value(&:clear_next)
  elves_moved
end

def map_elves(elves)
  elves.values.to_h { |e| [e.loc, e] }
end

def print_elves(elves)
  x_vals = elves.keys.map(&:first).minmax
  y_vals = elves.keys.map(&:last).minmax
  (y_vals.first..y_vals.last).each do |idy|
    (x_vals.first..x_vals.last).each do |idx|
      print elves.key?([idx, idy]) ? "#" : "."
    end
    print "\n"
  end
  print "\n"
end

def find_empty_squares(elves)
  width = elves.keys.map(&:first).minmax.inject(&:-).abs + 1
  height = elves.keys.map(&:last).minmax.inject(&:-).abs + 1
  width * height - elves.count
end

elves = get_elves(input)
index = 0
elves_moved = true

directions = ["N", "S", "W", "E"]

while elves_moved
  elves_moved = run_round(elves, directions)
  elves = map_elves(elves)
  directions.rotate!
  index += 1
  puts find_empty_squares(elves) if index == 10
end

puts index
