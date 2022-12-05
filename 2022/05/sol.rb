require_relative "../../aoc_input"

input = get_input(2022, 5).split("\n\n")

def build_crate_map(input)
  piles = input.last
  crates = {}
  piles.chars.each.with_index do |c, idx|
    next if c.to_i.zero?

    arr = []
    input[0...-1].reverse.each do |row|
      arr << row[idx] unless row[idx].strip.empty?
    end
    crates[c.to_i] = arr
  end

  crates
end

def move_crates(direction, crate_map)
  regex = /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/
  matches = regex.match(direction)
  matches[:count].to_i.times do
    crate = crate_map[matches[:from].to_i].pop
    crate_map[matches[:to].to_i] << crate
  end
end

def move_crates_advanced(direction, crate_map)
  regex = /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/
  matches = regex.match(direction)
  crates = crate_map[matches[:from].to_i].pop(matches[:count].to_i)
  crate_map[matches[:to].to_i] += crates
end

def print_crates(crate_map)
  tallest_stack = crate_map.values.map(&:length).max
  (0...tallest_stack).reverse_each do |v|
    crate_map.each_key do |k|
      printable = crate_map[k][v] ? " #{crate_map[k][v]} " : "   "
      print printable
    end
    print "\n"
  end

  print " "
  puts crate_map.keys.join("  ")
end

def print_top_crates(crate_map)
  puts crate_map.values.map(&:last).join
end

crate_map = build_crate_map(input[0].split("\n"))
crate_map_advanced = build_crate_map(input[0].split("\n"))

input[1].split("\n").each do |line|
  move_crates(line, crate_map)
  move_crates_advanced(line, crate_map_advanced)
end

print_top_crates(crate_map)
print_top_crates(crate_map_advanced)
