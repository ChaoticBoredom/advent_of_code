require_relative "../../aoc_input"

input = get_input(2021, 21).split("\n")

positions = input.map { |x| x.scan(/\d+/)[1].to_i }
scores = [0, 0]

def roll_dice(dice)
  dice += 1
  if dice > 100
    dice = 1
  end
  dice
end

def move(start_pos, dice)
  moves = 0
  3.times do
    dice = roll_dice(dice)
    moves += dice
  end
  new_pos = start_pos + moves
  new_pos = new_pos % 10 if new_pos > 10
  new_pos = 10 if new_pos == 0 # Account for 100
  [new_pos, dice]
end

def play_game(positions, scores)
  dice = 0
  dice_rolls = 0
  idx = 0
  until scores.any? { |x| x >= 1000 }
    player = idx % 2
    positions[player], dice = move(positions[player], dice)
    scores[player] += positions[player]
    dice_rolls += 3
    idx += 1
  end
  [scores, dice_rolls]
end

def add_move(position, dice_roll)
  position += dice_roll
  position = position % 10 if position > 10
  position = 10 if position == 0
  position
end

OUTCOMES = {3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1}
def quantum_game(positions, max_scores, idx, cache)
  player = idx % 2
  pl1_needed, pl2_needed = max_scores
  if max_scores.any? { |x| x <= 0 }
    return { max_scores.index { |x| x <= 0 } => 1}
  end
  output = cache[[positions, max_scores, player]]
  return output unless output.nil?

  output = { 0 => 0, 1 => 0 }
  OUTCOMES.each do |k, v|
    new_positions = positions.dup
    new_max_scores = max_scores.dup
    move = add_move(positions[player], k)
    new_positions[player] = move
    new_max_scores[player] -= move
    h = Hash[quantum_game(new_positions, new_max_scores, idx + 1, cache).map { |ki, vi| [ki, vi * v] }]
    output.merge!(h) { |_, a, b| a + b }
  end

  cache[[positions, max_scores, player]] = output
  return output
end

scores, dice_rolls = play_game(positions.dup, scores)

puts dice_rolls * scores.min
puts quantum_game(positions, [21, 21], 0, Hash.new).values.max