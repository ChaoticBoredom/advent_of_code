require_relative "../../aoc_input"

input = get_input(2022, 12).split("\n")

def find_loc(input, char)
  input.each.with_index do |line, idx|
    x = line.index(char)
    return [idx, x] if x
  end
end

def find_all_possible_starts(input)
  starts = []
  input.each.with_index do |line, idx|
    (0...line.length).find_all { |c| line[c] == "a" }.each do |c|
      starts << [idx, c]
    end
  end
  starts
end

def valid_next_step?(next_step, current, input)
  width = input[0].count
  height = input.count
  return false unless next_step[0].between?(0, height - 1)
  return false unless next_step[1].between?(0, width - 1)

  curr_height = input[current[0]][current[1]]
  next_height = input[next_step[0]][next_step[1]]

  return false unless next_height <= curr_height + 1

  true
end

def find_path(input, start, target)
  dirs = [[-1, 0], [0, 1], [1, 0], [0, -1]]

  search_path = start.map { |coord| [coord, 0] }
  path_taken = []

  until search_path.empty?
    loc, steps = search_path.shift
    next if path_taken.include?(loc)
    return steps if loc == target

    path_taken << loc
    dirs.each do |new_dir|
      next_step = [new_dir, loc].transpose.map { |x| x.reduce(:+) }
      search_path << [next_step, steps + 1] if valid_next_step?(next_step, loc, input)
    end
  end
end

start = find_loc(input, "S")
target = find_loc(input, "E")

possible_starts = find_all_possible_starts(input)
input[start[0]][start[1]] = "a"
input[target[0]][target[1]] = "z"
elevation = input.map(&:chars).map { |x| x.map { |y| y.ord - 96 } }

puts find_path(elevation, [start], target)
puts find_path(elevation, possible_starts, target)
