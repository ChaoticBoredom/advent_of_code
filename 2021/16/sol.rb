require_relative "../../aoc_input"

input = get_input(2021, 16).chars.map { |c| c.to_i(16).to_s(2).rjust(4, "0") }.join.chars

def get_version(input)
  v = input.shift(3)
  v.join.to_i(2)
end

def get_type(input)
  v = input.shift(3)
  v.join.to_i(2)
end

def get_number(input)
  v = input.shift(5)
  leader = v.shift

  [leader.to_i, v.join]
end

def get_operator_length(input)
  input.shift.to_i
end

def get_packet_size(input)
  input.shift(15).join.to_i(2)
end

def get_packet_count(input)
  input.shift(11).join.to_i(2)
end

def get_literal(input)
  nums = []
  Kernel.loop do
    leader, num = get_number(input)
    nums << num
    break if leader.zero?
  end
  [nums.join.to_i(2)]
end

def solve_operator_by_size(input, versions, nums)
  size = get_packet_size(input)
  start_size = input.size
  while input.size > start_size - size
    versions, new_num = parse(input, versions)
    nums += new_num
  end
  [versions, nums]
end

def solve_operator_by_count(input, versions, nums)
  size = get_packet_count(input)
  until nums.size >= size
    versions, new_num = parse(input, versions)
    nums += new_num
  end
  [versions, nums]
end

def solve_operator(type, nums)
  nums.flatten!
  case type
  when 0 then nums.sum
  when 1 then nums.inject(:*)
  when 2 then nums.min
  when 3 then nums.max
  when 5 then nums.first > nums.last ? 1 : 0
  when 6 then nums.first < nums.last ? 1 : 0
  when 7 then nums.first == nums.last ? 1 : 0
  end
end

def parse(input, versions)
  nums = []
  v = get_version(input)
  versions << v
  t = get_type(input)
  if t == 4
    res = get_literal(input)
  else
    l = get_operator_length(input)
    versions, nums =  case l
                      when 0 then solve_operator_by_size(input, versions, nums)
                      when 1 then solve_operator_by_count(input, versions, nums)
                      end
    res = solve_operator(t, nums)
  end
  [versions, [res]]
end

versions = []
versions, nums = parse(input, versions) while input.size.positive? && !input.map(&:to_i).all?(&:zero?)

puts versions.sum
puts nums.flatten
