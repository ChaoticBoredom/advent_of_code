require_relative "../../aoc_input"

input = get_input(2022, 21).split("\n")

DIGIT = /-?\d+/.freeze

def parse(input)
  monkeys = {}

  input.each do |line|
    monkey, job = line.split(": ")
    job = job.to_i if DIGIT.match(job)

    monkeys[monkey] = job
  end

  monkeys
end

def parse_monkey_job(job)
  /(\w+) (.*) (\w+)/.match(job)[1..]
end

def solve(monkeys, additional_case = false)
  monkeys.reject { |_, v| v.is_a?(Integer) }.each do |k, v|
    next if v == "notarealmonkey"
    m1, op, m2 = parse_monkey_job(v)
    if monkeys[m1].is_a?(Integer) && monkeys[m2].is_a?(Integer)

      res = monkeys[m1].to_s + op + monkeys[m2].to_s
      monkeys[k] = eval(res)
    end
  rescue NoMethodError
    binding.pry
  end
end

def reverse_solve(monkeys, monkey_to_solve, val = nil)
  return val if monkey_to_solve == "humn"
  job = monkeys[monkey_to_solve]
  m1, op, m2 = parse_monkey_job(job)
  m1_val = monkeys[m1]
  m2_val = monkeys[m2]

  val_to_find = m1_val.is_a?(Integer) ? m1_val : m2_val
  next_monkey = m1_val.is_a?(Integer) ? m2 : m1

  case op
  when "=="
    return reverse_solve(monkeys, next_monkey, val_to_find)
  when "*"
    return reverse_solve(monkeys, next_monkey, val / val_to_find)
  when "+"
    return reverse_solve(monkeys, next_monkey, val - val_to_find)
  when "/"
    return reverse_solve(monkeys, next_monkey, val * val_to_find) if m1 == next_monkey
    return reverse_solve(monkeys, next_monkey, val / val_to_find) if m2 == next_monkey
  when "-"
    return reverse_solve(monkeys, next_monkey, val_to_find - val) if m2 == next_monkey
    return reverse_solve(monkeys, next_monkey, val + val_to_find) if m1 == next_monkey
  end
end

monkeys = parse(input)
solve(monkeys) until monkeys.values.all? { |v| v.is_a?(Integer) }

puts monkeys["root"]


monkeys = parse(input)
op = /\w+ (.) \w+/.match(monkeys["root"])[1]
monkeys["root"].sub!(op, "==")
monkeys["humn"] = "notarealmonkey"

1000.times do
  solve(monkeys)
end

puts reverse_solve(monkeys, "root")
