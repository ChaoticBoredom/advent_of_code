require_relative "../../aoc_input"

WEAPONS = {
  :dagger => { :cost => 8, :damage => 4, :armor => 0 },
  :shortsword => { :cost => 10, :damage => 5, :armor => 0 },
  :warhammer => { :cost => 25, :damage => 6, :armor => 0 },
  :longsword => { :cost => 40, :damage => 7, :armor => 0 },
  :greataxe => { :cost => 74, :damage => 8, :armor => 0 },
}.freeze

ARMOR = {
  :none => { :cost => 0, :damage => 0, :armor => 0 },
  :leather => { :cost => 13, :damage => 0, :armor => 1 },
  :chainmail => { :cost => 31, :damage => 0, :armor => 2 },
  :splintmail => { :cost => 53, :damage => 0, :armor => 3 },
  :bandedmail => { :cost => 75, :damage => 0, :armor => 4 },
  :platemail => { :cost => 102, :damage => 0, :armor => 5 },
}.freeze

RINGS = {
  :none => { :cost => 0, :damage => 0, :armor => 0 },
  :none2 => { :cost => 0, :damage => 0, :armor => 0 },
  :dmg1 => { :cost => 25, :damage => 1, :armor => 0 },
  :dmg2 => { :cost => 50, :damage => 2, :armor => 0 },
  :dmg3 => { :cost => 100, :damage => 3, :armor => 0 },
  :def1 => { :cost => 20, :damage => 0, :armor => 1 },
  :def2 => { :cost => 40, :damage => 0, :armor => 2 },
  :def3 => { :cost => 80, :damage => 0, :armor => 3 },
}.freeze

input = get_input(2015, 21)

def parse_input(input)
  boss_hp = /Hit Points: (\d+)/.match(input).captures.first.to_i
  boss_damage = /Damage: (\d+)/.match(input).captures.first.to_i
  boss_armor = /Armor: (\d+)/.match(input).captures.first.to_i

  [boss_hp, boss_damage, boss_armor]
end

def run_battle(input, damage_bonus, armor_bonus)
  boss_hp, boss_damage, boss_armor = parse_input(input)
  player_hp = 100
  until player_hp <= 0
    boss_hp -= [damage_bonus - boss_armor, 1].max
    return true if boss_hp <= 0

    player_hp -= [boss_damage - armor_bonus, 1].max
  end
  false
end

def run_all_variations
  WEAPONS.each_value do |weapon|
    ARMOR.each_value do |armor|
      RINGS.keys.combination(2).to_a.map { |r| r.map { |r2| RINGS[r2] } }.uniq.each do |rings|
        cost = weapon[:cost] + armor[:cost] + rings.map { |r| r[:cost] }.sum

        damage_bonus = weapon[:damage] + rings.map { |r| r[:damage] }.sum
        armor_bonus = armor[:armor] + rings.map { |r| r[:armor] }.sum

        yield damage_bonus, armor_bonus, cost
      end
    end
  end
end

def find_cheapest_win(input)
  cheapest = Float::INFINITY
  run_all_variations do |damage_bonus, armor_bonus, cost|
    next unless run_battle(input, damage_bonus, armor_bonus)
    next unless cost < cheapest

    cheapest = cost
  end
  cheapest
end

def find_costliest_loss(input)
  costliest = -Float::INFINITY
  run_all_variations do |damage_bonus, armor_bonus, cost|
    next if run_battle(input, damage_bonus, armor_bonus)
    next unless cost > costliest

    costliest = cost
  end
  costliest
end

puts find_cheapest_win(input)
puts find_costliest_loss(input)
