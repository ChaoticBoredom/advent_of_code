require_relative "../../aoc_input"

# PAPER = "Y", "B"
# ROCK = "X", "A"
# SCISSORS = "Z", "C"

FIRST_ROUND_HASH = {
  "A" => { "X" => 3, "Y" => 6, "Z" => 0 },
  "B" => { "X" => 0, "Y" => 3, "Z" => 6 },
  "C" => { "X" => 6, "Y" => 0, "Z" => 3 },
}.freeze
MY_SCORE_HASH = { "X" => 1, "Y" => 2, "Z" => 3 }.freeze
SECOND_ROUND_HASH = {
  "A" => { "X" => 3, "Y" => 1, "Z" => 2 },
  "B" => { "X" => 1, "Y" => 2, "Z" => 3 },
  "C" => { "X" => 2, "Y" => 3, "Z" => 1 },
}.freeze
SECOND_SCORE_HASH = { "X" => 0, "Y" => 3, "Z" => 6 }.freeze

input = get_input(2022, 2).split("\n").map(&:split)

def score_round(opp, mine, hash1, hash2)
  hash1[opp][mine] + hash2[mine]
end

puts(input.sum { |x, y| score_round(x, y, FIRST_ROUND_HASH, MY_SCORE_HASH) })
puts(input.sum { |x, y| score_round(x, y, SECOND_ROUND_HASH, SECOND_SCORE_HASH) })
