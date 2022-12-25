require_relative "../../aoc_input"
require "set"

class Blueprint
  attr_accessor :ore, :clay, :obs_ore, :obs_clay, :geo_ore, :geo_obs, :id

  def initialize(data)
    @id = /Blueprint (\d+):/.match(data)[1].to_i
    @ore = /ore robot costs (\d+) ore/.match(data)[1].to_i
    @clay = /clay robot costs (\d+) ore/.match(data)[1].to_i
    obsidian_robot = /obsidian robot costs (\d+) ore and (\d+) clay/.match(data)
    @obs_ore = obsidian_robot[1].to_i
    @obs_clay = obsidian_robot[2].to_i
    geode_robot = /geode robot costs (\d+) ore and (\d+) obsidian/.match(data)
    @geo_ore = geode_robot[1].to_i
    @geo_obs = geode_robot[2].to_i
  end

  def biggest_ore_expense
    [@clay, @obs_ore, @geo_ore].max
  end

  def buy_ore_robot(state)
    state[0] -= @ore
    state[4] += 1
    state
  end

  def afford_ore?(state)
    state[0] >= @ore
  end

  def buy_clay_robot(state)
    state[0] -= @clay
    state[5] += 1
    state
  end

  def afford_clay?(state)
    state[0] >= @clay
  end

  def buy_obs_robot(state)
    state[0] -= @obs_ore
    state[1] -= @obs_clay
    state[6] += 1
    state
  end

  def afford_obs?(state)
    state[0] >= @obs_ore && state[1] >= @obs_clay
  end

  def buy_geo_robot(state)
    state[0] -= @geo_ore
    state[2] -= @geo_obs
    state[7] += 1
    state
  end

  def afford_geo?(state)
    state[0] >= @geo_ore && state[2] >= @geo_obs
  end
end

def get_best_geode_count(bp, time)
  best = 0
  queue = [[0, 0, 0, 0, 1, 0, 0, 0, time]]
  visited = {}
  until queue.empty?
    state = queue.shift
    next if visited.key?(state)

    visited[state] = true
    if state.last.zero?
      best = state[3] if best < state[3]
    else
      new_state = state.dup
      new_state[8] -= 1
      new_state[0] += new_state[4]
      new_state[1] += new_state[5]
      new_state[2] += new_state[6]
      new_state[3] += new_state[7]

      build_geo_bot = bp.afford_geo?(state)
      build_obs_bot = !build_geo_bot && state[6] < bp.geo_obs && bp.afford_obs?(state)
      build_clay_bot = !build_geo_bot && !build_obs_bot && state[5] < bp.obs_clay && bp.afford_clay?(state)
      build_ore_bot = !build_geo_bot && !build_obs_bot && state[4] < bp.biggest_ore_expense && bp.afford_ore?(state)
      build_nothing = !build_geo_bot && state[0] < 2 * bp.biggest_ore_expense && state[1] < 3 * bp.obs_clay

      queue << new_state if build_nothing

      queue << bp.buy_geo_robot(new_state.dup) if build_geo_bot
      queue << bp.buy_obs_robot(new_state.dup) if build_obs_bot
      queue << bp.buy_clay_robot(new_state.dup) if build_clay_bot
      queue << bp.buy_ore_robot(new_state.dup) if build_ore_bot
    end
  end
  best
end

input = get_input(2022, 19).chomp.split("\n")

blueprints = input.map { |i| Blueprint.new(i) }

puts blueprints.map { |bp| get_best_geode_count(bp, 24) * bp.id }.sum
puts blueprints[0..2].map { |bp| get_best_geode_count(bp, 32) }.inject(&:*)
