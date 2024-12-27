require_relative "../../aoc_input"

gates, wires = get_input(2024, 24).split("\n\n")

def build_gate_hash(gates)
  gates.split("\n").map { |x| x.split(": ") }.to_h.transform_values(&:to_i)
end

def parse_wire_list(wires)
  wires.split("\n").map { |l| /(\w+) (AND|XOR|OR) (\w+) -> (\w+)/.match(l).captures }
end

def check_gate(gates, wire)
  first, op, second, dest = wire
  case op
  when "AND"
    gates[dest] = [gates[first], gates[second]].all? { |x| x == 1 } ? 1 : 0
  when "OR"
    gates[dest] = [gates[first], gates[second]].include?(1) ? 1 : 0
  when "XOR"
    gates[dest] = gates[first] == gates[second] ? 0 : 1
  end
end

def solve_program(gates, wire_list)
  wire_list.cycle do |l|
    break if contains_all?(gates, wire_list)
    next unless gates.key?(l[0]) && gates.key?(l[2])

    check_gate(gates, l)
  end
  gates
end

def contains_all?(gates_hash, wire_list)
  dests = wire_list.map(&:last)

  (dests - gates_hash.keys).empty?
end

def combine_z(gates)
  zeds = gates.select { |k, _| k.start_with?("z") }
  zeds.sort.map(&:last).reverse.join.to_i(2)
end

def check_z00_wires(gates)
  wire = gates.select do |g1, _, g2, output|
    output == "z00" ||
      g1.start_with?("x00", "y00") ||
      g2.start_with?("x00", "y00")
  end

  wire.one? ? [] : wire
end

def check_zxx_wires(gates)
  gates.select do |_, _, _, output|
    next if output == "z00"

    output.start_with?("z")
  end
end

def check_remaining_adders(gates)
  gates.select do |g1, op, g2, out|
    op == "XOR" &&
      !(g1.start_with?("x") || g2.start_with?("x")) &&
      !out.start_with?("z")
  end
end

def check_zfinal_wire(gates, last_z)
  gates.select { |_, op, _, out| out == last_z && op != "OR" }
end

def check_adders_adjacent_to_outputs(adders, other_adders, possibles)
  adders.reject do |_, _, _, out|
    possibles.include?(out) ||
      out == "z00" ||
      !other_adders.select { |g1, _, g2, _| [g1, g2].include?(out) }.empty?
  end
end

def final_check(gates, to_check, other_adders)
  to_check.map do |g1, _, _, _|
    expected_num = "z#{/(\d+)/.match(g1).captures.first}"
    matches = other_adders.find { |_, _, _, out| out == expected_num }

    check_val = [matches[0], matches[2]]

    or_matches = gates.find { |_, op, _, out| op == "OR" && check_val.include?(out) }

    check_val.find { |x| x != or_matches.last }
  end
end

def find_swaps(wire_list, gates)
  possibles = []
  full_adders = gates.select do |g1, op, g2, _|
    (g1.start_with?("x") || g2.start_with?("x")) &&
      op == "XOR"
  end

  possibles += check_z00_wires(full_adders).map(&:last)
  possibles += check_zxx_wires(full_adders).map(&:last)

  remaining_adders = gates.select { |g1, op, g2, _| op == "XOR" && !(g1.start_with?("x") || g2.start_with?("x")) }

  possibles += remaining_adders.reject { |_, _, _, out| out.start_with?("z") }.map(&:last)

  outputs = gates.select { |_, _, _, out| out.start_with?("z") }

  last_z = format("z%02d", wire_list.count / 2)
  possibles += check_zfinal_wire(outputs, last_z).map(&:last)

  possibles += outputs.select { |_, op, _, out| out.start_with?("z") && op != "XOR" && out != last_z }.map(&:last)

  to_check = check_adders_adjacent_to_outputs(full_adders, remaining_adders, possibles)
  possibles += to_check.map(&:last)

  possibles += final_check(gates, to_check, remaining_adders)

  possibles
end

gh = build_gate_hash(gates)
wire_list = parse_wire_list(wires)
prog_gates = solve_program(gh.dup, wire_list)

puts combine_z(prog_gates)
puts find_swaps(gh, wire_list).sort.join(",")
