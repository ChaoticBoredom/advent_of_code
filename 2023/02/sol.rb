require_relative "../../aoc_input"

input = get_input(2023, 2).split("\n")

ids = []
powers = []
input.each do |val|
  id = val.scan(/Game (\d+):/).flatten.first.to_i
  imp_id = nil
  red_count = []
  green_count = []
  blue_count = []

  val.split(";").each do |game|
    reds = game.scan(/(\d+) red/).flatten.first.to_i
    red_count << reds
    imp_id = id if reds > 12

    greens = game.scan(/(\d+) green/).flatten.first.to_i
    green_count << greens
    imp_id = id if greens > 13

    blues = game.scan(/(\d+) blue/).flatten.first.to_i
    blue_count << blues
    imp_id = id if blues > 14
  end
  powers << (red_count.max * green_count.max * blue_count.max)
  ids << id unless imp_id == id
end

puts ids.sum
puts powers.sum
