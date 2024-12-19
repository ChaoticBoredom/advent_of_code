require_relative "../../aoc_input"

patterns, designs = get_input(2024, 19).split("\n\n")
patterns = patterns.split(", ")
designs = designs.split("\n")

def possible?(patterns, design)
  /^#{Regexp.union(*patterns)}+$/.match?(design)
end

@pattern_cache = {}

def count_patterns(patterns, design)
  return @pattern_cache[design] if @pattern_cache.key?(design)
  return 1 if design.empty?

  @pattern_cache[design] = patterns.
    select { |p| design.start_with?(p) }.
    map { |p| count_patterns(patterns, design[p.size..]) }.
    sum
end

puts designs.map { |d| possible?(patterns, d) }.count(true)
puts designs.map { |d| count_patterns(patterns, d) }.sum
