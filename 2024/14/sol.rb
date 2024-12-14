require_relative "../../aoc_input"
require "matrix"

input = get_input(2024, 14)

MAX_X = 101
MAX_Y = 103

def parse_input(input)
  input.split("\n").map do |line|
    px, py, vx, vy = /p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/.match(line).captures.map(&:to_i)
    [Vector[px, py], Vector[vx, vy]]
  end
end

def move_bot(bot)
  new_pos = bot.inject(:+)

  new_pos[0] += MAX_X if new_pos[0].negative?
  new_pos[1] += MAX_Y if new_pos[1].negative?

  new_pos[0] -= MAX_X if new_pos[0] >= MAX_X
  new_pos[1] -= MAX_Y if new_pos[1] >= MAX_Y

  [new_pos, bot[1]]
end

def map_bots_to_quadrants(robots)
  robo_tally = robots.map(&:first).tally

  [
    robo_tally.select { |k, _| k[0].between?(0, MAX_X / 2 - 1) && k[1].between?(0, MAX_Y / 2 - 1) }.values.sum,
    robo_tally.select { |k, _| k[0].between?(MAX_X / 2 + 1, MAX_X) && k[1].between?(0, MAX_Y / 2 - 1) }.values.sum,
    robo_tally.select { |k, _| k[0].between?(0, MAX_X / 2 - 1) && k[1].between?(MAX_Y / 2 + 1, MAX_Y) }.values.sum,
    robo_tally.select { |k, _| k[0].between?(MAX_X / 2 + 1, MAX_X) && k[1].between?(MAX_Y / 2 + 1, MAX_Y) }.values.sum,
  ]
end

def christmas_tree?(robots)
  robo_tally = robots.map(&:first).tally

  robo_tally.values.all? { |v| v == 1 }
end

def display_bots(robots)
  robo_tally = robots.map(&:first).tally

  (0...MAX_Y).to_a.each do |y|
    (0...MAX_X).to_a.each do |x|
      vec = Vector[x, y]
      print robo_tally.key?(vec) ? robo_tally[vec] : " "
    end
    print "\n"
  end
end

robots = parse_input(input)
100.times { robots = robots.map { |b| move_bot(b) } }

puts map_bots_to_quadrants(robots).inject(:*)

i = 1
Kernel.loop do
  robots = robots.map { |b| move_bot(b) }
  break if christmas_tree?(robots)

  i += 1
end

display_bots(robots) if ARGF.argv.include?("display")
puts i
