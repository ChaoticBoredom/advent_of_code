require_relative "../../aoc_input"

input = get_input(2021, 12).split("\n").map { |x| x.split("-") }

pathways = Hash.new([])

input.each do |x|
  a, b = x
  pathways[a] += [b]
  pathways[b] += [a]
end

pathways.each_key do |k|
  pathways[k].sort!
  pathways[k].sort_by! { |x| x == "end" ? 1 : 0 }
  pathways[k].reject! { |x| x == "start" }
end
pathways.delete("end")

def small?(cave)
  cave.match?(/^\p{Lower}+$/)
end

def traverse(pathways, doubled, visited, from, to)
  return 1 if from == to

  if visited.include?(from)
    return 0 if doubled || from == "start"

    doubled = true
  end
  pathways[from].sum do |dest|
    traverse(pathways, doubled, small?(from) ? visited + [from] : visited, dest, to)
  end
end

puts traverse(pathways, true, [], "start", "end")

puts traverse(pathways, false, [], "start", "end")
