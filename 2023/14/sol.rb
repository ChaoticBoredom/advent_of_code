require_relative "../../aoc_input"

input = get_input(2023, 14).split("\n")

def new_calc_load(input)
  max_y = input.count
  total = 0
  input.each.with_index do |row, idx|
    total += row.count("O") * (max_y - idx)
  end
  total
end

def tilt(input, dir)
  case dir
  when "N"
    slid_input = input.map(&:chars).transpose.map(&:join)
    res = slid_input.map do |row|
      row.split("#", -1).map { |s| s.chars.sort.reverse.join }.join("#")
    end
    res = res.map(&:chars).transpose.map(&:join)
  when "S"
    slid_input = input.map(&:chars).transpose.map(&:join)
    res = slid_input.map do |row|
      row.split("#", -1).map { |s| s.chars.sort.join }.join("#")
    end
    res = res.map(&:chars).transpose.map(&:join)
  when "W"
    res = input.map do |row|
      row.split("#", -1).map { |s| s.chars.sort.reverse.join }.join("#")
    end
  when "E"
    res = input.map do |row|
      row.split("#", -1).map { |s| s.chars.sort.join }.join("#")
    end
  end
  res
end

def spin(input)
  res = tilt(input, "N")
  res = tilt(res, "W")
  res = tilt(res, "S")
  tilt(res, "E")
end

tilted = tilt(input, "N")
puts new_calc_load(tilted)

maps = []
loop_start = nil
current = nil
res = input
1_000_000_000.times do |i|
  temp = res.join("\n")
  if maps.include?(temp)
    current = i
    break unless loop_start.nil?

    maps = []
    loop_start = i
  end

  maps << temp
  res = spin(res)
end

count = loop_start + (1_000_000_000 - loop_start) % (current - loop_start)

puts new_calc_load(maps[count - loop_start].split("\n"))
