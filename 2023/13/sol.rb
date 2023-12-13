require_relative "../../aoc_input"

input = get_input(2023, 13).split("\n\n").map { |l| l.split("\n") }

def find_reflection(landscape, difference_counter)
  1.upto(landscape.count) do |idx|
    top, bot = get_splits(landscape, idx)
    next if top.empty? || bot.empty?

    if difference_counter
      return idx if off_by_one?(top, bot.reverse)
    elsif top == bot.reverse
      return idx
    end
  end
  nil
end

def get_splits(landscape, idx)
  top = landscape.take(idx)
  bot = landscape.slice(idx, top.count)
  top = top.drop(top.count - bot.count) if top.count > bot.count
  [top, bot]
end

def find_reflections(landscape, difference_counter)
  h = find_reflection(landscape, difference_counter)
  return h * 100 unless h.nil?

  find_reflection(landscape.map { |l| l.split("") }.transpose, difference_counter)
end

def solve_part_one(input)
  input.sum { |landscape| find_reflections(landscape, false) }
end

def count_differences(vice, versa)
  t = versa.join.chars
  vice.join.chars.sum { |c| c == t.shift ? 0 : 1 }
end

def off_by_one?(vice, versa)
  count_differences(vice, versa) == 1
end

def solve_part_two(input)
  input.sum { |landscape| find_reflections(landscape, true) }
end

puts solve_part_one(input)
puts solve_part_two(input)
