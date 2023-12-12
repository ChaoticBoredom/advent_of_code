require_relative "../../aoc_input"

input = get_input(2023, 12).split("\n")

@cache = {}

def empty_checks(run_count, numbers)
  return 1 if run_count.nil? && numbers.count.zero?
  return 1 if numbers.one? && !run_count.nil? && run_count == numbers.first

  0
end

def sp_count(springs, run_count, numbers)
  return @cache[[springs, run_count, numbers]] if @cache.key?([springs, run_count, numbers])

  return empty_checks(run_count, numbers) if springs.empty?

  return 0 if springs[0] == "." && !run_count.nil? && run_count != numbers.first

  sc = 0
  first_char = springs[0]
  if run_count.nil?
    # Start new run
    sc += sp_count(springs[1..], 1, numbers) if ["#", "?"].include?(first_char)
    # Possible no run
    sc += sp_count(springs[1..], nil, numbers) if [".", "?"].include?(first_char)
  else
    # End of run
    sc += sp_count(springs[1..], nil, numbers[1..]) if first_char == "."
    # End of a possibility
    sc += sp_count(springs[1..], nil, numbers[1..]) if first_char == "?" && run_count == numbers.first
    # Continue the run
    sc += sp_count(springs[1..], run_count + 1, numbers) if ["#", "?"].include?(first_char)
  end

  @cache[[springs, run_count, numbers]] = sc
  sc
end

def find_possible_arrangements(springs, numeric)
  numbers = numeric.split(",").map(&:to_i)
  sp_count(springs, nil, numbers)
end

arrangements = []
arrangements_two = []

input.each do |line|
  springs, numbers = line.split(" ")
  arrangements << find_possible_arrangements(springs, numbers)

  full_springs = ([springs] * 5).join("?")
  full_numbers = ([numbers] * 5).join(",")
  arrangements_two << find_possible_arrangements(full_springs, full_numbers)
end

puts arrangements.sum
puts arrangements_two.sum
