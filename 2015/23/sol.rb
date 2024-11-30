require_relative "../../aoc_input"

input = get_input(2015, 23).split("\n")

def run_program(input, registers)
  line_idx = 0
  while line_idx < input.count
    case input[line_idx]
    when /hlf (a|b)/
      registers[Regexp.last_match(1)] /= 2
      line_idx += 1
    when /tpl (a|b)/
      registers[Regexp.last_match(1)] *= 3
      line_idx += 1
    when /inc (a|b)/
      registers[Regexp.last_match(1)] += 1
      line_idx += 1
    when /jmp ((\+|-)\d+)/
      line_idx += Regexp.last_match(1).to_i
    when /jie (a|b), ((\+|-)\d+)/
      line_idx += registers[Regexp.last_match(1)].even? ? Regexp.last_match(2).to_i : 1
    when /jio (a|b), ((\+|-)\d+)/
      line_idx += registers[Regexp.last_match(1)] == 1 ? Regexp.last_match(2).to_i : 1
    else
      return registers
    end
  end

  registers
end

puts run_program(input, { "a" => 0, "b" => 0 })["b"]
puts run_program(input, { "a" => 1, "b" => 0 })["b"]
