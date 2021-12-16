require_relative "../../aoc_input"

input = get_input(2021, 15).split("\n").map { |x| x.split("").map(&:to_i) }

def ordinals(x, y)
  [
    [x + 1, y],
    [x - 1, y],
    [x, y - 1],
    [x, y + 1],
  ]
end

def contained?(input, new_x, new_y)
  return false if new_x.negative?
  return false if new_x > input.first.size - 1
  return false if new_y.negative?
  return false if new_y > input.size - 1

  true
end

def get_shortest_path(input)
  map = [[0, 0, 0]]
  costs = Hash.new(0)
  Kernel.loop do
    cost, x, y = map.first
    if x == input.first.size - 1 && y == input.size - 1
      puts cost
      break
    end

    map.shift
    ordinals(x, y).each do |new_x, new_y|
      next unless contained?(input, new_x, new_y)

      new_cost = cost + input[new_y][new_x]
      next if costs.key?([new_x, new_y]) && costs[[new_x, new_y]] <= new_cost

      costs[[new_x, new_y]] = new_cost
      map << [new_cost, new_x, new_y]
    end
    map.sort!
  end
end

def build_bigger_map(input)
  super_map = []
  input.each_with_index do |y, idy|
    y.each_with_index do |x, idx|
      5.times do |x_inc|
        5.times do |y_inc|
          new_val = x + x_inc + y_inc
          new_val = new_val % 10 + 1 if new_val > 9
          super_map[idy + y_inc * y.size] ||= []
          super_map[idy + y_inc * y.size][idx + x_inc * input.size] = new_val
        end
      end
    end
  end
  super_map
end

puts get_shortest_path(input)
puts get_shortest_path(build_bigger_map(input))
