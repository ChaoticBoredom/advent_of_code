require_relative "../../aoc_input"
require "set"

input = get_input(2023, 23).split("\n")

DIRS = {
  "^" => [0, -1],
  "v" => [0, 1],
  ">" => [1, 0],
  "<" => [-1, 0],
}.freeze

class Node
  attr_accessor :id, :location, :direction

  def initialize(location, id)
    @id = id
    @location = location
    @neighbours = {}
  end

  def add_neighbour(neighbour, steps, direction)
    return if @neighbours.key?(neighbour.id)

    @neighbours[neighbour.id] = [neighbour, steps, direction]
  end

  def valid_moves(forced)
    return @neighbours.values.map(&:first) unless forced

    @neighbours.values.select { |v| v[2] }.map(&:first)
  end

  def get_steps(neighbour_id)
    @neighbours[neighbour_id][1]
  end

  def inspect
    content = instance_variables.map do |i|
      values = { :i => i, :var => instance_variable_get(i).inspect }
      format("%<i>s=%<var>s", values) if i != :@neighbours
    end
    content << "@neighbours=#{@neighbours.map { |k, v| [k, v[1], v[2]] }}"
    "<#{self.class.name}:0x#{object_id.to_s(16)} #{content.compact.join(' ')}>"
  end
end

def parse_input(input)
  start_point = end_point = nil
  map = {}
  input.each.with_index do |line, y|
    start_point = [line.index("."), y] if y.zero?
    line.chars.each.with_index do |c, x|
      next if c == "#"

      map[[x, y]] = c
    end
    end_point = y
  end
  end_point = [input[end_point].index("."), end_point]
  [map, start_point, end_point]
end

def build_graph(map, start_point)
  id = 0
  start_node = Node.new(start_point, id)
  queue = [[start_point, start_point, start_node]]
  nodes = { start_point => start_node }
  checked = Set.new
  until queue.empty?
    loc, origin, prev_node = queue.pop
    next if checked.include?([loc, origin])

    checked << [loc, origin]
    new_point, steps, next_tests, direction = find_next_crossroads(map, loc, Set.new([origin]))
    new_node = nodes.fetch(new_point, Node.new(new_point, id += 1))
    nodes[new_point] = new_node

    prev_node.add_neighbour(new_node, steps, direction >= 0)
    new_node.add_neighbour(prev_node, steps, direction <= 0)
    next_tests.each { |t| queue << [t, new_point, new_node] }
  end
  nodes
end

def find_next_crossroads(map, start_point, visited)
  queue = [start_point]
  transition = nil
  until queue.empty?
    loc = queue.pop
    new_paths = []
    DIRS.each_value do |v|
      test_key = loc.zip(v).map(&:sum)
      new_paths << test_key if map.key?(test_key) && !visited.include?(test_key)
    end
    if new_paths.count > 1 || new_paths.empty?
      direction = get_direction(map, transition, loc)
      return [loc, visited.count, new_paths, direction]
    end

    visited << loc
    transition = loc
    queue << new_paths.first
  end
end

def get_direction(map, transition, loc)
  return 0 if map[transition] == "."

  new_loc = DIRS[map[transition]].zip(transition).map(&:sum)
  new_loc == loc ? 1 : -1
end

def find_longest(s_p, e_p, forced)
  @end_point = e_p
  dfs([s_p], Set.new, 0, forced)
end

def dfs(queue, visited, steps, forced)
  longest = -1
  until queue.empty?
    loc = queue.pop
    return steps if loc == @end_point

    visited << loc
    n = loc.valid_moves(forced).reject { |m| visited.include?(m) }
    return -1 if n.empty?

    if n.count > 1
      n.each do |nl|
        distance = loc.get_steps(nl.id)
        new_count = dfs([nl], visited.dup, steps + distance, forced)
        longest = new_count if new_count > longest
      end
    else
      queue << n.first
      steps += loc.get_steps(n.first.id)
    end
  end
  longest
end

map, sp, ep = parse_input(input)
graph = build_graph(map, sp)

puts find_longest(graph[sp], graph[ep], true)
puts find_longest(graph[sp], graph[ep], false)
