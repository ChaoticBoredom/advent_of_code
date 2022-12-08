require_relative "../../aoc_input"

input = get_input(2022, 8).split("\n").map(&:chars).map { |x| x.map(&:to_i) }

def check_left(idx, idy, input, tree)
  (idx - 1).downto(0) do |x|
    return false unless input[idy][x] < tree
  end
  true
end

def check_right(idx, idy, input, tree)
  (idx + 1).upto(input.first.size - 1) do |x|
    return false unless input[idy][x] < tree
  end
  true
end

def check_up(idx, idy, input, tree)
  (idy - 1).downto(0) do |y|
    return false unless input[y][idx] < tree
  end
  true
end

def check_down(idx, idy, input, tree)
  (idy + 1).upto(input.size - 1) do |y|
    return false unless input[y][idx] < tree
  end
  true
end

def check_visibility(idx, idy, input, tree)
  return true if idx.zero? || idx == input.first.size - 1
  return true if idy.zero? || idy == input.size - 1

  check_left(idx, idy, input, tree) ||
    check_right(idx, idy, input, tree) ||
    check_up(idx, idy, input, tree) ||
    check_down(idx, idy, input, tree)
end

def count_left(idx, idy, input, tree)
  sum = 0
  (idx - 1).downto(0) do |x|
    sum += 1
    return sum if input[idy][x] >= tree
  end
  sum
end

def count_right(idx, idy, input, tree)
  sum = 0
  (idx + 1).upto(input.first.size - 1) do |x|
    sum += 1
    return sum if input[idy][x] >= tree
  end
  sum
end

def count_up(idx, idy, input, tree)
  sum = 0
  (idy - 1).downto(0) do |y|
    sum += 1
    return sum if input[y][idx] >= tree
  end
  sum
end

def count_down(idx, idy, input, tree)
  sum = 0
  (idy + 1).upto(input.size - 1) do |y|
    sum += 1
    return sum if input[y][idx] >= tree
  end
  sum
end

def scenic_score(idx, idy, input, tree)
  count_left(idx, idy, input, tree) *
    count_right(idx, idy, input, tree) *
    count_up(idx, idy, input, tree) *
    count_down(idx, idy, input, tree)
end

visible = 0
max_scenic = 0
input.each.with_index do |line, idy|
  line.each.with_index do |tree, idx|
    visible += 1 if check_visibility(idx, idy, input, tree)
    scenic = scenic_score(idx, idy, input, tree)
    max_scenic = scenic if scenic > max_scenic
  end
end

puts visible
puts max_scenic
