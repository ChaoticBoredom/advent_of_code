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

MAPPINGS = [
  /seed-to-soil map:/,
  /soil-to-fertilizer map:/,
  /fertilizer-to-water map:/,
  /water-to-light map:/,
  /light-to-temperature map:/,
  /temperature-to-humidity map:/,
  /humidity-to-location map:/,
].map { |v| get_mappings(input.select { |l| l.match?(v) }.first) }

puts solve_part_1
puts solve_part_2
