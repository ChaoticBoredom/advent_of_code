require_relative "../../aoc_input"

input = get_input(2023, 11).split("\n")

def map_universe(input)
  blank_lines = []
  input.each.with_index do |line, j|
    next if line.include?("#")

    blank_lines << j
  end

  blank_columns = []
  input.first.each_char.with_index do |_, i|
    blank_columns << i if input.map { |l| l[i] == "." }.all?
  end

  [blank_lines, blank_columns]
end

def add_spaces(blanks, val, expansion_rate)
  new_num = val
  blanks.each { |idx| new_num += expansion_rate if idx < val }
  new_num
end

def map_galaxies(input, expansion_rate)
  blank_lines, blank_columns = map_universe(input)
  galaxies = []
  input.each.with_index do |line, j|
    line.each_char.with_index do |c, i|
      next unless c == "#"

      gj = add_spaces(blank_lines, j, expansion_rate)
      gi = add_spaces(blank_columns, i, expansion_rate)
      galaxies << [gi, gj]
    end
  end
  galaxies
end

def distance(galaxy1, galaxy2)
  xdiff = (galaxy2[0] - galaxy1[0]).abs
  ydiff = (galaxy2[1] - galaxy1[1]).abs
  xdiff + ydiff
end

def solve(input, expansion_rate)
  galaxies = map_galaxies(input, expansion_rate)
  distances = []
  galaxies.permutation(2).to_a.map(&:sort).uniq.each do |g1, g2|
    distances << distance(g1, g2)
  end
  distances.sum
end

puts solve(input, 1)
puts solve(input, 999_999)
