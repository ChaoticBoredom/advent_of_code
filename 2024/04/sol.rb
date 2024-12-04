require_relative "../../aoc_input"

input = get_input(2024, 4)

def find_horizontals(input)
  input.scan(/XMAS/).count + input.scan(/SAMX/).count
end

def find_verticals(input)
  transposed = input.split("\n").
    map(&:chars).
    transpose.
    map { |x| x.join("") }.
    join("\n")
  find_horizontals(transposed)
end

DIRS = [
  [1, 1],
  [1, -1],
  [-1, 1],
  [-1, -1],
].freeze

def check_diagonals(arr, row, col, dir)
  return unless (row + 3 * dir[1]).between?(0, arr.first.count - 1)
  return unless (col + 3 * dir[0]).between?(0, arr.count - 1)

  return unless arr[col + 1 * dir[0]][row + 1 * dir[1]] == "M"
  return unless arr[col + 2 * dir[0]][row + 2 * dir[1]] == "A"
  return unless arr[col + 3 * dir[0]][row + 3 * dir[1]] == "S"

  true
end

def find_diagonals(input)
  count = 0
  arr = input.split("\n").map(&:chars)
  arr.each.with_index do |line, j|
    line.each.with_index do |c, i|
      next unless c == "X"

      DIRS.each { |dir| count += 1 if check_diagonals(arr, i, j, dir) }
    end
  end
  count
end

def find_x_mas(input)
  count = 0
  arr = input.split("\n").map(&:chars)
  arr.each.with_index do |line, j|
    next unless j.between?(1, arr.count - 2)

    line.each.with_index do |c, i|
      next unless i.between?(1, arr.first.count - 2)
      next unless c == "A"

      diag1 = [arr[j + 1][i + 1], c, arr[j - 1][i - 1]].join
      diag2 = [arr[j - 1][i + 1], c, arr[j + 1][i - 1]].join

      count += 1 if [diag1, diag2].all? { |x| /(SAM|MAS)/.match(x) }
    end
  end
  count
end

puts find_horizontals(input) +
     find_verticals(input) +
     find_diagonals(input)
puts find_x_mas(input)
