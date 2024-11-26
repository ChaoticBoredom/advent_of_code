require_relative "../../aoc_input"

input = get_input(2015, 6).split("\n")

lights = Hash.new(false)
brights = Hash.new(0)

def parse_line(line)
  results = /(?<action>\D*)(?<corner1>\d+,\d+) through (?<corner2>\d+,\d+)/.match(line).named_captures

  action = results["action"].chomp(" ")
  corner1 = results["corner1"].split(",").map(&:to_i)
  corner2 = results["corner2"].split(",").map(&:to_i)

  x_range, y_range = corner1.zip(corner2).map { |x| x.each_slice(2).map { |a, b| a..b } }.flatten
  [action, x_range, y_range]
end

def on_off(lights, action, x_range, y_range)
  case action
  when "turn on"
    iterate(lights, x_range, y_range) { |_| true }
  when "toggle"
    iterate(lights, x_range, y_range, &:!)
  when "turn off"
    iterate(lights, x_range, y_range) { |_| false }
  end
end

def increase_brightness(lights, action, x_range, y_range)
  case action
  when "turn on"
    iterate(lights, x_range, y_range) { |v| v + 1 }
  when "toggle"
    iterate(lights, x_range, y_range) { |v| v + 2 }
  when "turn off"
    iterate(lights, x_range, y_range) { |v| [v - 1, 0].max }
  end
end

def iterate(light_hash, x_range, y_range, &action_method)
  x_range.each do |x|
    y_range.each do |y|
      light_hash[[x, y]] = action_method.call(light_hash[[x, y]])
    end
  end
end

input.each do |l|
  a, c1, c2 = parse_line(l)
  on_off(lights, a, c1, c2)
  increase_brightness(brights, a, c1, c2)
end

puts lights.values.count(true)
puts brights.values.sum
