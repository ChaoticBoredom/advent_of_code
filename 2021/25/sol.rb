require_relative "../../aoc_input"

input = get_input(2021, 25).split("\n").map { |x| x.split("") }

locs = {}

input.each.with_index do |line, idy|
  line.each.with_index do |char, idx|
    next if char == "."

    locs[[idx, idy]] = char
  end
end

def step_east(cucumbers, new_cucumbers)
  max_x, = cucumbers.keys.max_by { |x, _| x }
  east = cucumbers.select { |_, v| v == ">" }
  east.each do |k, v|
    x, y = k
    new_loc = x + 1 > max_x ? [0, y] : [x + 1, y]
    unless cucumbers.key?(new_loc)
      new_cucumbers[new_loc] = v
      next
    end

    new_cucumbers[k] = v
  end
  new_cucumbers
end

def step_south(cucumbers, new_cucumbers)
  _, max_y = cucumbers.keys.max_by { |_, y| y }
  south = cucumbers.select { |_, v| v == "v" }
  south.each do |k, v|
    x, y = k
    new_loc = y + 1 > max_y ? [x, 0] : [x, y + 1]
    unless new_cucumbers.key?(new_loc) || cucumbers[new_loc] == "v"
      new_cucumbers[new_loc] = v
      next
    end
    new_cucumbers[k] = v
  end
  new_cucumbers
end

def step(cucumbers)
  new_cucumbers = step_east(cucumbers, {})
  step_south(cucumbers, new_cucumbers)
end

def print_map(cucumbers)
  x, = cucumbers.keys.max_by { |x, _| x }
  _, y = cucumbers.keys.max_by { |_, y| y }
  0.upto(y).each do |idy|
    0.upto(x).each do |idx|
      print cucumbers[[idx, idy]] || "."
    end
    print "\n"
  end
  print "\n"
end

count = 0
new_locs = {}
Kernel.loop do
  new_locs = step(locs)
  count += 1
  break if new_locs == locs

  locs = new_locs
end

puts count
