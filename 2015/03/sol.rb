require_relative "../../aoc_input"

input = get_input(2015, 3).chars

current_loc = [0, 0]
visited = Hash.new(0)
visited[current_loc.dup] += 1

input.each do |char|
  current_loc[0] += 1 if char == ">"
  current_loc[0] -= 1 if char == "<"
  current_loc[1] += 1 if char == "^"
  current_loc[1] -= 1 if char == "v"
  visited[current_loc.dup] += 1
end

puts visited.keys.count

current_loc = [0, 0]
robo_loc = [0, 0]
visited = Hash.new(0)
visited[current_loc.dup] += 1
visited[robo_loc.dup] += 1

input.each.with_index do |char, idx|
  loc = current_loc if idx.even?
  loc = robo_loc if idx.odd?
  loc[0] += 1 if char == ">"
  loc[0] -= 1 if char == "<"
  loc[1] += 1 if char == "^"
  loc[1] -= 1 if char == "v"
  visited[loc.dup] += 1
end

puts visited.keys.count
