require_relative "../../aoc_input"

input = get_input(2023, 25).split("\n")

def build_graph(input)
  graph = Hash.new { |h, k| h[k] = [] }

  input.each do |l|
    source, targets = l.split(": ")
    targets = targets.split(" ")
    targets.each do |t|
      graph[source] << t
      graph[t] << source
    end
  end

  graph
end

def find_min_cut(graph)
  vertices = graph.keys
  n = vertices.size

  10_000.times do
    g = graph.transform_values(&:dup)

    groups = {}
    vertices.each { |v| groups[v] = [v] }

    remaining = vertices.dup
    while remaining.size > 2
      v = remaining.sample
      next if g[v].empty?

      u = g[v].sample
      g[v].concat(g[u]).reject! { |x| [u, v].include?(x) }
      remaining.delete(u)

      groups[v].concat(groups[u])
      groups.delete(u)

      g.each_value { |edges| edges.map! { |x| x == u ? v : x } }
    end

    cut_size = g[remaining.first].size

    next unless cut_size == 3

    g1_size = groups[remaining.first].size
    g2_size = n - g1_size
    return g1_size * g2_size
  end
end

graph = build_graph(input)
puts find_min_cut(graph)
