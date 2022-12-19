require_relative "../../aoc_input"

input = get_input(2022, 17).chomp.chars

rocks = [
  ["####", [[0, 0], [1, 0], [2, 0], [3, 0]]],
  [" # \n###\n # ", [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]]],
  ["  #\n  #\n###", [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]]],
  ["#\n#\n#\n#", [[0, 0], [0, 1], [0, 2], [0, 3]]],
  ["##\n##", [[0, 0], [0, 1], [1, 0], [1, 1]]],
]

ROCKS_SIZE = rocks.size
JETS_SIZE = input.size

def resting?(pos, height, stack, rock)
  return height <= 0 if stack.empty?

  overlaps?(pos, height, rock.last, stack)
end

def valid?(edge, height, rock, dir, stack)
  new_val = edge.first + dir

  return false if new_val < edge.min && dir.negative?
  return false if new_val > edge.max && dir.positive?
  return true if stack.empty?

  !overlaps?(new_val, height, rock, stack)
end

def map_rock(height, edge, rock)
  rock.map { |x, y| [x + edge, y + height] }
end

def add_to_stack(height, edge, rock, stack)
  map_rock(height, edge, rock).each { |c| stack[c] = "#" }
end

def overlaps?(edge, height, rock, stack)
  next_pos = map_rock(height, edge, rock)
  next_pos.each do |val|
    return true if stack.key?(val)
  end
  false
end

def max_height(stack)
  stack.empty? ? 0 : stack.keys.max_by { |_, y| y }[1]
end

def get_edge_range(rock_shape)
  (2..(7 - rock_shape.split("\n").first.size)).to_a + [0, 1]
end

def drop_rock(rock, jets, stack)
  stack_max = max_height(stack)
  height = stack_max + 4
  left_side_edge = get_edge_range(rock.first)
  until resting?(left_side_edge.first, height, stack, rock)
    move, = jets.next
    dir = move == "<" ? -1 : 1

    left_side_edge.rotate!(dir) if valid?(left_side_edge, height, rock.last, dir, stack)

    height -= 1
  end
  height += 1 unless stack.empty?
  add_to_stack(height, left_side_edge.first, rock.last, stack)
end

def cache_stack(stack, cache, move_idx, iter_count, height_cache)
  max_height = max_height(stack)
  key = generate_key(stack, max_height, move_idx, iter_count)
  height_cache[iter_count] = max_height
  return key if cache.key?(key)

  cache[key] = [max_height, iter_count]
  false
end

def generate_key(stack, height, move_idx, iter_count)
  peaks = (0..6).map { |x| stack.keys.select { |ix, _| ix == x }.max_by { |_, iy| iy } }
  mods = [move_idx % JETS_SIZE, iter_count % ROCKS_SIZE]
  peaks.map { |_, y| y - height unless y.nil? } + mods
end

def calc_future_pattern(stack, cache, height_cache, iter_count, key)
  old_height, old_count = cache[key]
  current_height = max_height(stack)
  change = current_height - old_height
  cycle_size = iter_count - old_count
  goal = 1_000_000_000_000 - old_count
  num_cycles, remaining = goal.divmod(cycle_size)
  missing_height = height_cache[old_count + remaining] - old_height

  old_height + missing_height + (num_cycles * change)
end

def print_chart(stack)
  idy = stack.keys.max_by { |_, y| y }[1]
  while idy >= 0
    print "|"
    7.times do |idx|
      print stack[[idx, idy]] || "."
    end
    idy -= 1
    print "|\n"
  end
  puts "\n"
end

rocks_cycle = rocks.cycle
jets_cycle = input.cycle.with_index
stack = {}

2022.times do
  drop_rock(rocks_cycle.next, jets_cycle, stack)
end

puts stack.keys.max_by { |_, y| y }[1] + 1

rocks_cycle.rewind
jets_cycle.rewind
stack = Hash.new(".")
cache = {}
height_cache = {}
key = nil

1_000_000_000_000.times do |iter_count|
  drop_rock(rocks_cycle.next, jets_cycle, stack)
  key = cache_stack(stack, cache, jets_cycle.peek[1], iter_count, height_cache)
  if key
    puts calc_future_pattern(stack, cache, height_cache, iter_count, key)
    break
  end
end
