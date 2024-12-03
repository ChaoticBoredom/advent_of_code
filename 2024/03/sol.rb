require_relative "../../aoc_input"

input = get_input(2024, 3)

def solve_mul(mul)
  val1, val2 = /(\d+),(\d+)/.match(mul).captures.map(&:to_i)
  val1 * val2
end

def base_multiply(input)
  input.scan(/mul\(\d+,\d+\)/).map { |mul| solve_mul(mul) }
end

def get_muls_and_toggles(input)
  muls = input.enum_for(:scan, /mul\(\d+,\d+\)/).map { |x| [x, Regexp.last_match.begin(0)] }
  dos = input.enum_for(:scan, /do\(\)/).map { [true, Regexp.last_match.begin(0)] }
  donts = input.enum_for(:scan, /don't\(\)/).map { [false, Regexp.last_match.begin(0)] }
  toggles = (dos + donts).sort_by { |_, y| y }

  [muls, toggles]
end

def toggled_multiple(input)
  muls, toggles = get_muls_and_toggles(input)

  on_or_off = true
  valid_muls = []
  toggles.each do |change, index|
    v1, v2 = muls.partition { |x| x[1] < index }

    valid_muls += v1 if on_or_off
    on_or_off = change

    muls = v2
  end

  valid_muls += muls if on_or_off

  valid_muls.map { |mul| solve_mul(mul.first) }
end

puts base_multiply(input).sum
puts toggled_multiple(input).sum
