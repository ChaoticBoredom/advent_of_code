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
      player_data[:armor] = SPELLS[k][:armor]
    when :recharge
      player_data[:mana] += SPELLS[k][:mana_restore]
    end
  end
end

def clear_spell_effects(player_data, effects)
  effects.each do |k, v|
    effects.delete(k) if v <= 0
  end
  player_data[:armor] = 0
end

def run_battle(player_data, boss_data, effects, used_mana, hard_mode: false)
  until boss_data[:hp] <= 0 || player_data[:hp] <= 0
    if hard_mode
      player_data[:hp] -= 1
      break if boss_data[:hp] <= 0 || player_data[:hp] <= 0
    end

    run_turn(player_data, boss_data, effects) { used_mana = player_turn(player_data, effects, used_mana) }
    break if boss_data[:hp] <= 0 || player_data[:hp] <= 0

    run_turn(player_data, boss_data, effects) { boss_turn(player_data, boss_data) }
  end

  winner = boss_data[:hp] <= 0 ? "player" : "boss"
  [winner, used_mana]
end

def run_turn(player_data, boss_data, effects)
  apply_spell_effects(boss_data, player_data, effects)
  yield
  clear_spell_effects(player_data, effects)
end

def player_turn(player_data, effects, used_mana)
  return used_mana if SPELLS.values.all? { |v| v[:mana] > player_data[:mana] }

  spell_to_cast = nil
  loop do
    spell_to_cast = SPELLS.keys.sample(random: Random.new(@val += 1))
    break if player_data[:mana] >= SPELLS[spell_to_cast][:mana]
  end

  player_data[:mana] -= SPELLS[spell_to_cast][:mana]
  used_mana += SPELLS[spell_to_cast][:mana]

  effects[spell_to_cast] = SPELLS[spell_to_cast].key?(:duration) ? SPELLS[spell_to_cast][:duration] : 1

  used_mana
end

def boss_turn(player_data, boss_data)
  player_data[:hp] -= [boss_data[:damage] - player_data[:armor], 1].max
end

player_data = { :hp => 50, :mana => 500, :armor => 0 }
boss_data = parse_input(input)

# Despite using sample, enforcing the seed ensures repeated results
@val = 400_000
puts 100_000.times.map { run_battle(player_data.dup, boss_data.dup, {}, 0) }.
  reject { |x| x.first == "boss" }.
  min_by(&:last).
  last

@val = 1_300_000
puts 100_000.times.map { run_battle(player_data.dup, boss_data.dup, {}, 0, hard_mode: true) }.
  reject { |x| x.first == "boss" }.
  min_by(&:last).
  last
