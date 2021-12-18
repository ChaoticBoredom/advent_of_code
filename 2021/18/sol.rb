require_relative "../../aoc_input"

input = get_input(2021, 18).split("\n")

def explode(line, pair, idx)
  halves = [line[0..(idx - 1)], line.slice(idx, pair.size), line[(idx + pair.size)..-1]]
  left_nums, nums, right_nums = halves.map { |x| x.scan(/\d+/).map(&:to_i) }
  unless left_nums.empty?
    left_search = Regexp.new(".*\\K#{left_nums.last}")
    halves[0].sub!(left_search, (left_nums.last + nums[0]).to_s)
  end
  halves[2].sub!(right_nums.first.to_s, (right_nums.first + nums[1]).to_s) unless right_nums.empty?
  halves[1] = "0"
  halves.join
end

def split(line, number)
  line.sub!(number.to_s, "[#{number / 2},#{(number / 2.0).ceil}]")
end

def get_all_indices(line, value)
  line.enum_for(:scan, value).map { Regexp.last_match.begin(0) }
end

def reduce_snail_fish(line)
  pairs = line.scan(/\[\d+,\d+\]/)
  pair_counter = Hash.new(0)
  pairs.each do |x|
    idx = get_all_indices(line, x)
    idx = idx[pair_counter[x]]
    nest_depth =  line.slice(0, idx).scan(/\[/).count -
                  line.slice(0, idx).scan(/\]/).count
    return explode(line, x, idx) if nest_depth >= 4

    pair_counter[x] += 1
  end

  splits = line.scan(/\d{2,}/)
  return split(line, splits.first.to_i) unless splits.empty?

  nil
end

def parse_snailfish(line)
  Kernel.loop do
    new_line = reduce_snail_fish(line)
    break if new_line.nil?

    line = new_line
  end
  line
end

def add_number(line, new_line)
  "[#{line},#{new_line}]"
end

def get_magnitude(line)
  Kernel.loop do
    pairs = line.scan(/\[\d+,\d+\]/)
    return line if pairs.empty?

    number = pairs.first
    a, b = number[1, 10].split(",").map(&:to_i)
    line.sub!(pairs.first, (a * 3 + b * 2).to_s)
  end
end

line = input.first
input[1, input.size].each do |new_line|
  line = add_number(line, new_line)
  line = parse_snailfish(line)
end

puts get_magnitude(line)

permutations = input.permutation(2)

magnitudes = []
permutations.each do |a, b|
  magnitudes << get_magnitude(parse_snailfish(add_number(a, b)))
end

puts magnitudes.map(&:to_i).max
