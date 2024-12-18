require_relative "../../aoc_input"

input = get_input(2024, 17)

def parse_input(input)
  registers = input.scan(/Register (A|B|C): (\d+)/).to_h.transform_values(&:to_i)

  program = /Program: (.+)/.match(input).captures.first.split(",").map(&:to_i)
  [registers, program]
end

def run_program(program, registers)
  pointer = 0

  output = []

  while pointer < program.count
    instruction, operand = program[pointer..(pointer + 1)]

    combo_op = transform_operand(operand, registers)

    case instruction
    when 0 then registers["A"] = registers["A"] / 2**combo_op
    when 1 then registers["B"] = registers["B"] ^ operand
    when 2 then registers["B"] = combo_op % 8
    when 3
      break if registers["A"].zero?

      pointer = operand
      next
    when 4 then registers["B"] = registers["B"] ^ registers["C"]
    when 5 then output << combo_op % 8
    when 6 then registers["B"] = registers["A"] / 2**combo_op
    when 7 then registers["C"] = registers["A"] / 2**combo_op
    end

    pointer += 2
  end

  output
end

def transform_operand(operand, registers)
  case operand
  when 0..3
    operand
  when 4
    registers["A"]
  when 5
    registers["B"]
  when 6
    registers["C"]
  when 7
    puts "NOT VALID"
  end
end

def reverse_program(program)
  test_vals = [[program, program.count - 1, 0]]
  until test_vals.count.zero?
    program, offset, val = test_vals.shift
    (0...8).to_a.each do |x|
      next_val = (val << 3) + x
      next unless run_program(program, { "A" => next_val, "B" => 0, "C" => 0 }) == program[offset..]

      return next_val if offset.zero?

      test_vals << [program, offset - 1, next_val]
    end
  end
end

registers, program = parse_input(input)

puts run_program(program, registers).join(",")
puts reverse_program(program)
