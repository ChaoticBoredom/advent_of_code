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

def adjust_lights(lights, brights, line)
  a, x_range, y_range = parse_line(line)
  x_range.to_a.product(y_range.to_a).each do |coords|
    case a
    when "turn on"
      lights[coords] = true
      brights[coords] = brights[coords] + 1
    when "toggle"
      lights[coords] = !lights[coords]
      brights[coords] = brights[coords] + 2
    when "turn off"
      lights[coords] = false
      brights[coords] = [brights[coords] - 1, 0].max
    end
  end
end

input.each { |l| adjust_lights(lights, brights, l) }

puts lights.values.count(true)
puts brights.values.sum
