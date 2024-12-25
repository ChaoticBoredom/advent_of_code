require_relative "../../aoc_input"

schematics = get_input(2024, 25).split("\n\n")

def get_keys_and_locks(schematics)
  schematics.partition do |x|
    lines = x.split("\n")
    lines.first.chars.all? { |c| c == "." } && lines.last.chars.all? { |c| c == "#" }
  end
end

def get_tumber_data(schematic)
  schematic.split("\n").map(&:chars).transpose.map { |x| x.count("#") - 1 }
end

def matches?(key, lock)
  key.zip(lock).map { |a, b| a + b }.all? { |x| x <= 5 }
end

keys, locks = get_keys_and_locks(schematics)

mapped_keys = keys.map { |s| get_tumber_data(s) }
mapped_locks = locks.map { |s| get_tumber_data(s) }

puts mapped_keys.product(mapped_locks).map { |k, l| matches?(k, l) }.count(true)
