require_relative "../../aoc_input"

input = get_input(2021, 11).split("\n").map { |x| x.split("").map(&:to_i) }
octopus_hash = Hash.new([0, false])

input.each.with_index do |line, idy|
  line.each.with_index do |octopus, idx|
    octopus_hash[[idx, idy]] = [octopus, false]
  end
end

flash_count = 0

DIR_DIFFS = [
  [-1, -1],
  [0, -1],
  [1, -1],
  [-1, 0],
  [1, 0],
  [-1, 1],
  [0,  1],
  [1,  1],
].freeze

def increment_neighbours(h, loc)
  x, y = loc
  DIR_DIFFS.each do |x_diff, y_diff|
    next if (x + x_diff) > h.keys.map(&:first).max
    next if (x + x_diff).negative?
    next if (y + y_diff) > h.keys.map(&:last).max
    next if (y + y_diff).negative?

    h[[x + x_diff, y + y_diff]][0] += 1
  end
end

def flash_octopi(h, flash_count)
  until h.select { |_, v| v[0] > 9 && !v[1] }.empty?
    h.select { |_, v| v[0] > 9 && !v[1] }.each do |k, _|
      h[k][1] = true
      flash_count += 1
      increment_neighbours(h, k)
    end
  end
  flash_count
end

def make_step(h, flash_count)
  h.each do |k, _|
    h[k][0] += 1
  end
  flash_octopi(h, flash_count)
end

def reset_hash(octopus_hash)
  octopus_hash.each do |k, v|
    next unless v.last

    octopus_hash[k] = [0, false]
  end
end

def print_hash(h)
  0.upto(h.keys.map(&:first).max) do |x|
    0.upto(h.keys.map(&:last).max) do |y|
      print h[[x, y]][0]
    end
    print "\n"
  end
end

idx = 0
sync = nil
while sync.nil?
  idx += 1
  flash_count = make_step(octopus_hash, flash_count)
  puts flash_count if idx == 100
  reset_hash(octopus_hash)
  sync = idx if octopus_hash.reject { |_, v| v[0].zero? }.empty?
end

puts sync
