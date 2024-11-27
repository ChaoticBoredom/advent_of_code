require_relative "../../aoc_input"

input = get_input(2015, 17).split("\n")

containers = input.map(&:to_i)

variation_count = (1..containers.size).reduce([]) do |subset, count|
  subset.concat(containers.combination(count).select { |c| c.sum == 150 })
end

puts variation_count.count
puts variation_count.min_by(&:count).count
