require_relative "../../aoc_input"
require "matrix"

input = get_input(2024, 21).split("\n")

DIRS = {
  "v" => Vector[0, -1],
  "^" => Vector[0, 1],
  ">" => Vector[-1, 0],
  "<" => Vector[1, 0],
}.freeze

NUMPAD = {
  "7" => Vector[2, 3], "8" => Vector[1, 3], "9" => Vector[0, 3],
  "4" => Vector[2, 2], "5" => Vector[1, 2], "6" => Vector[0, 2],
  "1" => Vector[2, 1], "2" => Vector[1, 1], "3" => Vector[0, 1],
                       "0" => Vector[1, 0], "A" => Vector[0, 0]
}.freeze

DIRPAD = {
                       "^" => Vector[1, 1], "A" => Vector[0, 1],
  "<" => Vector[2, 0], "v" => Vector[1, 0], ">" => Vector[0, 0]
}.freeze

def find_shortest_differences(start, goal, bad_fields)
  return [nil] if (start - goal).zero?

  options = []

  diffx, diffy = *(goal - start)
  options += diffx.negative? ? [">"] * diffx.abs : ["<"] * diffx
  options += diffy.negative? ? ["v"] * diffy.abs : ["^"] * diffy

  options.permutation.to_a.uniq.select do |opt_set|
    all_moves = opt_set.inject([start]) { |origin, move| origin + [origin.last + DIRS[move]] }
    (all_moves & bad_fields).empty?
  end
end

def get_pad_and_avoids(current_bot)
  [
    current_bot.zero? ? NUMPAD : DIRPAD,
    current_bot.zero? ? [Vector[2, 0]] : [Vector[2, 1]],
  ]
end

@paths_hash = {}
def shortest_path(code, bot_count, current_bot = 0)
  hkey = [code, current_bot, bot_count]
  return @paths_hash[hkey] if @paths_hash.key?(hkey)

  pad, avoids = get_pad_and_avoids(current_bot)

  start_loc = pad["A"]
  length = 0

  code.chars.each do |c|
    next_loc = pad[c]
    moves = find_shortest_differences(start_loc, next_loc, avoids)
    length += if current_bot == bot_count
                "#{moves.first&.join}A".length
              else
                moves.map { |m| shortest_path("#{m&.join}A", bot_count, current_bot + 1) }.min
              end
    start_loc = next_loc
  end
  @paths_hash[hkey] = length
end

def calc_complexity(code, paths)
  paths.map(&:length).min * code.to_i
end

res = input.map do |code|
  [
    shortest_path(code, 2) * code.to_i,
    shortest_path(code, 25) * code.to_i,
  ]
end

puts res.map(&:first).sum
puts res.map(&:last).sum
