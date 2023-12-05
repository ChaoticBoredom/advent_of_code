require_relative "../../aoc_input"

input = get_input(2023, 5).split("\n\n")

def solve_part_1
  locations = []
  SEED_NUMBERS.each do |seed|
    locations << get_location(seed)
  end

  locations.min
end

def solve_part_2
  start = 0
  [10_000, 1000, 100, 10, 1].each do |inc|
    start = count_up(start, inc)
    start -= inc unless inc == 1
  end
  start
end

def count_up(start, increment)
  location = start
  seeds = []
  SEED_NUMBERS.each_slice(2) do |seed, range|
    seeds << (seed...(seed + range))
  end

  while true
    location += increment

    return location if is_seed?(location, seeds)
  end
end

def get_seeds(str)
  str.scan(/\d+/).map(&:to_i)
end

def get_mappings(str)
  mappings = str.split("\n")[1..-1]

  mappings.map do |line|
    dest_range, source_range, range_length = line.scan(/\d+/).map(&:to_i)
    [
      source_range - dest_range,
      source_range...(source_range + range_length),
      dest_range...(dest_range + range_length),
    ]
  end
end

def get_location(seed)
  MAPPINGS.each do |mapping|
    seed = get_next_val(seed, mapping)
  end
  seed
end

def is_seed?(location, seeds)
  MAPPINGS.reverse.each do |mapping|
    location = get_prev_val(location, mapping)
  end
  seeds.any? { |r| r.cover?(location) }
end

def get_prev_val(val, mapping)
  mapping.each do |change, _, dest|
    return val + change if dest.cover?(val)
  end
  val
end

def get_next_val(val, mapping)
  mapping.each do |change, source, _|
    return val - change if source.cover?(val)
  end
  val
end

SEED_NUMBERS = get_seeds(input.select { |v| v.match?(/seeds: /) }.first )
SEED_TO_SOIL = get_mappings(input.select { |v| v.match?(/seed-to-soil map:/) }.first )
SOIL_TO_FERT = get_mappings(input.select { |v| v.match?(/soil-to-fertilizer map:/) }.first )
FERT_TO_WATER = get_mappings(input.select { |v| v.match?(/fertilizer-to-water map:/) }.first )
WATER_TO_LIGHT = get_mappings(input.select { |v| v.match?(/water-to-light map:/) }.first )
LIGHT_TO_TEMP = get_mappings(input.select { |v| v.match?(/light-to-temperature map:/) }.first )
TEMP_TO_HUMID = get_mappings(input.select { |v| v.match?(/temperature-to-humidity map:/) }.first )
HUMID_TO_LOC = get_mappings(input.select { |v| v.match?(/humidity-to-location map:/) }.first )

MAPPINGS = [SEED_TO_SOIL, SOIL_TO_FERT, FERT_TO_WATER, WATER_TO_LIGHT, LIGHT_TO_TEMP, TEMP_TO_HUMID, HUMID_TO_LOC]

puts solve_part_1
puts solve_part_2
