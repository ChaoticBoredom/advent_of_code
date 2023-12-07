require_relative "../../aoc_input"

input = get_input(2023, 3).split("\n")

def build_grid(input)
  grid = Hash.new(".")
  input.each.with_index do |val, idy|
    val.chars.each.with_index do |c, idx|
      grid[[idx, idy]] = c
    end
  end
  grid
end

def get_part_numbers(input, grid)
  part_numbers = []
  input.each.with_index do |val, idy|
    val.gsub(/\d+/).map do |v|
      idx_start, idx_end = Regexp.last_match.offset(0)

      part_numbers << v.to_i if symbol_adjacent?(grid, idx_start, idx_end, idy)
    end
  end

  part_numbers
end

def symbol_adjacent?(grid, x_start, x_end, y)
  [y - 1, y, y + 1].each do |idy|
    Range.new((x_start - 1), x_end).to_a.each do |idx|
      next if idy == y && idx.between?(x_start, x_end - 1)

      return true unless grid[[idx, idy]] == "."
    end
  end
  false
end

def get_gear_numbers(grid)
  adjacent_gears = []
  grid.each_pair do |key, value|
    next unless value == "*"

    adjacent_gears << get_gear_adjacent(grid, key[0], key[1])
  end

  adjacent_gears.select { |gp| gp.count > 1 }
end

def get_gear_adjacent(grid, x, y)
  gears = []

  [y - 1, y, y + 1].each do |idy|
    [x - 1, x, x + 1].each do |idx|
      next unless /\d+/.match?(grid[[idx, idy]])

      gears << get_full_number(grid, idx, idy) unless grid[[idx, idy]].match?(/\+d/)
    end
  end
  gears.uniq
end

def get_full_number(grid, idx, idy)
  str = Range.new(idx - 3, idx + 3).to_a.map { |x| grid[[x, idy]] }.join("")
  str.scan(/\D(\d+)\D/).flatten.first.to_i
end

grid = build_grid(input)

puts get_part_numbers(input, grid).sum

puts get_gear_numbers(grid).map { |x| x.flatten.inject(:*) }.sum
