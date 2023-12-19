require_relative "../../aoc_input"

wf, rt = get_input(2023, 19).split("\n\n")

class Part
  attr_accessor :x, :m, :a, :s

  def initialize(string)
    @x = string.match(/x=(\d+)/)[1].to_i
    @m = string.match(/m=(\d+)/)[1].to_i
    @a = string.match(/a=(\d+)/)[1].to_i
    @s = string.match(/s=(\d+)/)[1].to_i
  end

  def val(string)
    case string
    when "x" then @x
    when "m" then @m
    when "a" then @a
    when "s" then @s
    end
  end

  def sum
    @x + @m + @a + @s
  end
end

def workflows(input = nil)
  return @workflows unless @workflows.nil?

  @workflows = {}
  input.split("\n").each do |line|
    name, rules = line[0..-2].split("{")
    @workflows[name] = rules.split(",")
  end
  @workflows
end

def parts(input = nil)
  return @parts unless @parts.nil?

  @parts = []
  input.split("\n").each do |line|
    @parts << line.match(/x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)/).named_captures.transform_values(&:to_i)
  end
  @parts
end

workflows(wf)
parts(rt)

def test_part(part, tests)
  tests.each do |t|
    return t unless t.include?(":")

    val, cond, int, next_workflow = t.scan(/(x|m|a|s)(<|>)(\d+):(\w+)/).flatten
    part_val = part[val]

    result = cond == "<" ? part_val < int.to_i : part_val > int.to_i
    return next_workflow if result
  end
end

def check_part(part, workflows)
  current = "in"
  current = test_part(part, workflows[current]) until ["A", "R"].include?(current)

  current == "A"
end

def new_ranges(old_range, int, cond)
  if cond == "<"
    dest_range = (old_range.first)..(int - 1)
    after_range = int..(old_range.last)
  else
    dest_range = (int + 1)..(old_range.last)
    after_range = (old_range.first)..int
  end
  [dest_range, after_range]
end

def acceptable_combos(possibilities, current)
  return 0 if current == "R"
  return possibilities.values.map(&:size).inject(:*) if current == "A"

  total = 0
  possibilities = possibilities.dup

  workflows[current].each do |t|
    break unless t.include?(":")

    val, cond, int, next_workflow = t.scan(/(x|m|a|s)(<|>)(\d+):(\w+)/).flatten
    dest_range, after_range = new_ranges(possibilities[val], int.to_i, cond)

    possibilities[val] = dest_range
    total += acceptable_combos(possibilities, next_workflow)
    possibilities[val] = after_range
  end

  total += acceptable_combos(possibilities, workflows[current].last)
  total
end

accepted = parts.select { |p| check_part(p, workflows) }
puts accepted.map(&:values).flatten.sum

possibilities = {
  "x" => 1..4000,
  "m" => 1..4000,
  "a" => 1..4000,
  "s" => 1..4000,
}
puts acceptable_combos(possibilities, "in")
