require_relative "../../aoc_input"

input = get_input(2022, 16).split("\n")

class Valve
  attr_accessor :name, :flow_rate, :tunnels

  def initialize(data)
    @name = data.match(/Valve (.*) has/)[1]
    @flow_rate = data.match(/flow rate=(\d+)/)[1].to_i
    @tunnels = data.match(/to valves? (.*)/)[1].split(", ")
  end
end

class Agent
  attr_accessor :valve, :time

  def initialize(valve, time)
    @valve = valve
    @time = time
  end
end

class State
  attr_accessor :total_pressure, :current_valve, :agents, :remaining_time

  def initialize(total_pressure, current_valve, agents, remaining_time)
    @total_pressure = total_pressure
    @current_valve = current_valve
    @agents = agents
    @remaining_time = remaining_time
  end
end

def make_graph(input)
  edges = Hash.new { |h, k| h[k] = Hash.new(999) }
  valves = input.map { |line| Valve.new(line) }.map { |v| [v.name, v] }.to_h
  valves.map { |k, v| v.tunnels.map { |t| edges[k][t] = 1 } }
  nodes = valves.transform_values(&:flow_rate)
  nodes.keys.product(nodes.keys, nodes.keys).each do |x, y, z|
    edges[y][z] = [edges[y][z], edges[y][x] + edges[x][z]].min
  end
  nodes = nodes.reject { |_, v| v.zero? }.sort_by { |_, v| -v }.to_h
  edges.each do |valve, value|
    value.select! { |k, _| k != valve && (nodes.key?(k) || k == "AA") }
    value.transform_values! { |v| v + 1 }
  end

  [edges, nodes]
end

def get_pressure_release(graph, valve, times, valid_nodes)
  edges, nodes = graph
  idx = times.index(times.max)
  times[idx] -= edges[valve].values_at(*valid_nodes).min
  nodes[valve] * [times[idx], 0].max
end

def get_all_possible_moves(agents, remaining, nodes, edges)
  agents.permutation.flat_map do |a|
    remaining.map do |dest|
      new_time = a.first.time - edges[a.first.valve][dest]
      a2 = a.clone
      a2[0] = Agent.new(dest, new_time)
      State.new(nodes[dest] * new_time, dest, a2, new_time)
    end
  end
end

def get_pressure_released_by_move(move, graph, opened, init_pressure, cache)
  move.total_pressure +
    depth_first_search(
      graph,
      move.agents,
      (opened + [move.current_valve]),
      init_pressure + move.total_pressure,
      cache
    )
end

def depth_first_search(graph, agents, opened, init_pressure, cache)
  key = [agents, opened]
  return cache[key] if cache.key?(key)

  edges, nodes = graph

  remaining = nodes.keys - opened
  times = agents.map(&:time)
  valid_nodes = agents.map(&:valve) + remaining

  est = remaining.sum { |r| get_pressure_release(graph, r, times, valid_nodes) }
  return -9999 if init_pressure + est <= @best

  moves = get_all_possible_moves(agents, remaining, nodes, edges)

  moves = moves.select { |s| s.remaining_time.positive? }.
          sort_by! { |s| -s.remaining_time }.
          map { |s| get_pressure_released_by_move(s, graph, opened, init_pressure, cache) }

  cache[key] = moves.max || 0
  @best = [@best, init_pressure + cache[key]].max
  cache[key]
end

graph = make_graph(input)

cache = {}
@best = 0
depth_first_search(graph, [Agent.new("AA", 30)], [], 0, cache)
puts @best

cache = {}
@best = 0
depth_first_search(graph, [Agent.new("AA", 26), Agent.new("AA", 26)], [], 0, cache)
puts @best