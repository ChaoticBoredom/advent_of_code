require_relative "../../aoc_input"

class Node
  attr_accessor :name, :left, :right

  def initialize(node)
    @name, dirs = node.split(" = ")
    @left, @right = dirs[1..-2].split(", ")
  end
end

instructions, nodes = get_input(2023, 8).split("\n\n")
instructions = instructions.split("")
node_map = {}
nodes.split("\n").each do |n|
  nn = Node.new(n)
  node_map[nn.name] = nn
end

def find_end(start_node, final_node, node_map, instructions, start_idx)
  current_node = start_node
  step = nil
  start_idx.step do |i|
    idx = i % instructions.size
    dir = instructions[idx]
    node = node_map[current_node]
    new_node = dir == "L" ? node.left : node.right
    current_node = new_node
    step = i + 1
    break if current_node.match?(final_node)
  end
  [step, current_node]
end

def part_one(node_map, instructions)
  s, = find_end("AAA", /ZZZ/, node_map, instructions, 0)
  s
end

def part_two(node_map, instructions)
  current_nodes = node_map.keys.select { |k| k.match(/..A/) }
  steps = []
  current_nodes.each do |node|
    first, n = find_end(node, /..Z/, node_map, instructions, 0)
    second, = find_end(n, /..Z/, node_map, instructions, first)
    steps << second - first
  end

  steps.reduce(1, :lcm)
end

puts part_one(node_map, instructions)
puts part_two(node_map, instructions)
