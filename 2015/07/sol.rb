require_relative "../../aoc_input"

input = get_input(2015, 7).split("\n")

def int?(val)
  val.to_i.to_s == val
end

def get_values(line_match, wires)
  a, _, b = line_match.captures
  return false unless int?(a) || wires.key?(a) || a.empty?
  return false unless int?(b) || wires.key?(b)

  val_a = (int?(a) ? a.to_i : wires[a]) unless a.empty?
  val_b = int?(b) ? b.to_i : wires[b]

  [val_a, val_b]
end

def connect_wires(line, wires)
  action, dest = line.split(" -> ")
  line_match = /^(\w*)\s*(AND|RSHIFT|OR|LSHIFT|NOT) (\w*)/.match(action)
  val_a, val_b = get_values(line_match, wires) if line_match

  return false if val_b.nil? && line_match

  case action
  when /AND/
    wires[dest] = val_a & val_b
  when /OR/
    wires[dest] = val_a | val_b
  when /LSHIFT/
    wires[dest] = val_a << val_b
  when /RSHIFT/
    wires[dest] = val_a >> val_b
  when /NOT/
    wires[dest] = ~val_b
  else
    return false unless int?(action) || wires.key?(action)

    wires[dest] = int?(action) ? action.to_i : wires[action]
  end

  wires[dest] += 65_536 if wires[dest].negative?

  true
end

def build_circuit(input)
  duped_input = input.dup

  wires = {}
  until duped_input.empty?
    line = duped_input.shift

    duped_input.push(line) unless connect_wires(line, wires)
  end
  wires
end

wires = build_circuit(input)
puts wires["a"]

input.delete_if { |x| /\w* -> b$/.match(x) }
input.unshift("#{wires['a']} -> b")

puts build_circuit(input)["a"]
