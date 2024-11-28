require_relative "../../aoc_input"

ADJACENTS = [
  [-1, 0],
  [-1, 1],
  [-1, -1],
  [1, 0],
  [1, 1],
  [1, -1],
  [0, 1],
  [0, -1],
].freeze

input = get_input(2015, 18)

def step(lights)
  new_lights = lights.dup
  lights.each do |k, v|
    adjacent_lights = 0
    ADJACENTS.each do |change|
      adjacent_key = [change, k].transpose.map(&:sum)
      light_state = lights.fetch(adjacent_key, nil)
      adjacent_lights += light_state == "#" ? 1 : 0
    end
    if v == "#"
      new_lights[k] = "." unless [2, 3].include?(adjacent_lights)
    elsif adjacent_lights == 3
      new_lights[k] = "#"
    end
  end
  new_lights
end

def modified_step(lights)
  lights[[0, 0]] = "#"
  lights[[99, 0]] = "#"
  lights[[0, 99]] = "#"
  lights[[99, 99]] = "#"
  lights = step(lights)
  lights[[0, 0]] = "#"
  lights[[99, 0]] = "#"
  lights[[0, 99]] = "#"
  lights[[99, 99]] = "#"
  lights
end

lights = parse_input_as_hash_of_symbols(input)
100.times { lights = step(lights) }

puts lights.values.tally["#"]

lights = parse_input_as_hash_of_symbols(input)
100.times { lights = modified_step(lights) }

puts lights.values.tally["#"]
