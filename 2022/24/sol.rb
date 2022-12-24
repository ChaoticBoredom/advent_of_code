require_relative "../../aoc_input"

input = get_input(2022, 24).chomp.split("\n").map(&:chars)

START = [input[0].index("."), 0].freeze
TARGET = [input.last.index("."), input.count - 1].freeze
RIGHT_EDGE = input[0].count - 1
BOTTOM = input.count - 1

DIRS = {
  ">" => [1, 0],
  "<" => [-1, 0],
  "^" => [0, -1],
  "v" => [0, 1],
}.freeze

blizzards = {}
input.each.with_index do |line, idy|
  line.each.with_index do |char, idx|
    next if char == "."
    next if char == "#"

    blizzards[[idx, idy]] = [char]
  end
end

def print_map(blizzards)
  (0..BOTTOM).each do |idy|
    (0..RIGHT_EDGE).each do |idx|
      char = blizzards[[idx, idy]]
      char = ["#"] if char.nil? && (idy.zero? || idx.zero? || idx == RIGHT_EDGE || idy == BOTTOM)
      char = ["."] if [START, TARGET].include?([idx, idy]) || char.nil?

      print char.count == 1 ? char.first : char.count
    end
    print "\n"
  end
  print "\n"
end

def move_once(blizzards)
  next_blizzards = {}
  blizzards.each do |loc, chars|
    chars.each do |c|
      change = DIRS[c]
      new_loc = [loc, change].transpose.map { |x| x.inject(&:+) }
      new_loc[0] = 1 if new_loc[0] == RIGHT_EDGE
      new_loc[0] = RIGHT_EDGE - 1 if new_loc[0].zero?
      new_loc[1] = 1 if new_loc[1] == BOTTOM
      new_loc[1] = BOTTOM - 1 if new_loc[1].zero?

      next_blizzards.key?(new_loc) ? next_blizzards[new_loc] << c : next_blizzards[new_loc] = [c]
    end
  end
  next_blizzards
end

all_blizzards = { 0 => blizzards }

((RIGHT_EDGE - 1) * (BOTTOM - 1) + 2).times do |time|
  blizzards = move_once(blizzards)
  all_blizzards[time + 1] = blizzards
end

visited = {}

queue = [[*START, 0, false, false]]
first_traversal = true

until queue.empty?
  x, y, time, hit_end, hit_start = queue.shift
  
  next unless x.between?(0, RIGHT_EDGE) && y.between?(0, BOTTOM) && input[y][x] != "#"

  if TARGET == [x, y]
    puts time if first_traversal
    first_traversal = false
    hit_end = true
    if hit_end && hit_start
      puts time
      return
    end
  end

  hit_start = true if START == [x, y] && hit_end

  next if visited.key?([x, y, time, hit_end, hit_start])

  visited[[x, y, time, hit_end, hit_start]] = true

  next_round = all_blizzards[time + 1]

  queue << [x, y, time + 1, hit_end, hit_start] unless next_round.key?([x, y])
  queue << [x + 1, y, time + 1, hit_end, hit_start] unless next_round.key?([x + 1, y])
  queue << [x - 1, y, time + 1, hit_end, hit_start] unless next_round.key?([x - 1, y])
  queue << [x, y + 1, time + 1, hit_end, hit_start] unless next_round.key?([x, y + 1])
  queue << [x, y - 1, time + 1, hit_end, hit_start] unless next_round.key?([x, y - 1])
end
