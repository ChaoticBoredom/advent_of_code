require_relative "../../aoc_input"

input = get_input(2015, 9).split("\n")

def build_graph(input)
  captures = input.map { |l| /(\w+) to (\w+) = (\d+)/.match(l).captures }

  distances = {}

  captures.each do |start, dest, dist|
    distances[[start, dest].sort] = dist.to_i
  end

  distances
end

def find_all(distances)
  distances.keys.flatten.uniq.permutation.map do |p|
    p.each_cons(2).inject(0) { |s, key| s + distances[key.sort] }
  end
end

distances = build_graph(input)

res = find_all(distances)

puts res.minmax
