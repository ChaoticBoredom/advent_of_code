require_relative "../../aoc_input"

input = get_input(2015, 22)

SPELLS = {
  :magic_missle => { :mana => 53, :damage => 4 },
  :drain => { :mana => 73, :damage => 2, :heal => 2 },
  :shield => { :mana => 113, :duration => 6, :armor => 7 },
  :poison => { :mana => 173, :duration => 6, :damage => 3 },
  :recharge => { :mana => 229, :duration => 5, :mana_restore => 101 },
}.freeze

def parse_input(input)
  boss_hp = /Hit Points: (\d+)/.match(input).captures.first.to_i
  boss_damage = /Damage: (\d+)/.match(input).captures.first.to_i

  { :hp => boss_hp, :damage => boss_damage }
end

def apply_spell_effects(boss_data, player_data, effects)
  effects.each_key do |k|
    effects[k] -= 1
    case k
    when :magic_missle, :poison
      boss_data[:hp] -= SPELLS[k][:damage]
    when :drain
      boss_data[:hp] -= SPELLS[k][:damage]
      player_data[:hp] += SPELLS[k][:heal]
    when :shield
      player_data[:armor] = effects[k] <= 0 ? 0 : SPELLS[k][:armor]
    when :recharge
      player_data[:mana] += SPELLS[k][:mana_restore]
    end

    effects.delete(k) if effects[k] <= 0
  end
end

def run_battle(input, effects, used_mana, hard_mode: false)
  boss_data = parse_input(input)
  player_data = { :hp => 50, :mana => 500, :armor => 0 }

  until boss_data[:hp] <= 0 || player_data[:hp] <= 0
    player_data[:hp] -= 1 if hard_mode
    break if boss_data[:hp] <= 0 || player_data[:hp] <= 0

    used_mana = player_turn(player_data, boss_data, effects, used_mana)
    break if boss_data[:hp] <= 0 || player_data[:hp] <= 0

    boss_turn(player_data, boss_data, effects)
  end

  winner = boss_data[:hp] <= 0 ? "player" : "boss"
  [winner, used_mana]
end

def player_turn(player_data, boss_data, effects, used_mana)
  apply_spell_effects(boss_data, player_data, effects)

  return used_mana if SPELLS.values.all? { |v| v[:mana] > player_data[:mana] }

  spell_to_cast = nil
  loop do
    spell_to_cast = SPELLS.keys.reject { |k| effects.keys.include?(k) }.sample
    break if player_data[:mana] >= SPELLS[spell_to_cast][:mana]
  end

  player_data[:mana] -= SPELLS[spell_to_cast][:mana]
  used_mana += SPELLS[spell_to_cast][:mana]

  effects[spell_to_cast] = SPELLS[spell_to_cast].key?(:duration) ? SPELLS[spell_to_cast][:duration] : 1

  used_mana
end

def boss_turn(player_data, boss_data, effects)
  apply_spell_effects(boss_data, player_data, effects)

  player_data[:hp] -= [boss_data[:damage] - player_data[:armor], 1].max
end

puts 200_000.times.map { run_battle(input, {}, 0) }.
  reject { |x| x.first == "boss" }.
  min_by(&:last).
  last

puts 200_000.times.map { run_battle(input, {}, 0, hard_mode: true) }.
  reject { |x| x.first == "boss" }.
  min_by(&:last).
  last
