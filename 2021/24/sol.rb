require_relative "../../aoc_input"

program = get_input(2021, 24).split("\n").each_slice(18).to_a

# inp w
# mul x 0
# add x z
# mod x 26
# div z \d+
# add x (-)?\d+
# eql x w
# eql x 0
# mul y 0
# add y 25
# mul y x
# add y 1
# mul z y
# mul y 0
# add y w
# add y \d+
# mul y x
# add z y

def run_program(program, input)
  w = x = y = z = 0
  program.each do |line|
    w = input.pop
    x = z
    x %= 26
    z /= line[4].match(/\d+/)[0].to_i
    x += line[5].match(/-?\d+/)[0].to_i
    x = x == w ? 1 : 0
    x = x.zero? ? 1 : 0
    y = 25
    y *= x
    y += 1
    z *= y
    y = w
    y += line[15].match(/\d+/)[0].to_i
    y *= x
    z += y
  end
  z
end

def find_rules(program)
  uniqs = program.map.with_index do |line, idx|
    [
      idx,
      line[5].match(/-?\d+/)[0].to_i,
      line[15].match(/\d+/)[0].to_i,
    ]
  end
  stack = []
  uniqs.map do |idx, x, _|
    stack << idx if x.positive?
    next if x.positive?

    prev = stack.pop
    "num[#{idx}] = num[#{prev}] + #{uniqs[prev][2] + x}"
  end.compact
end

def find_max(program)
  rules = find_rules(program)
  num = [9] * 14
  rules.each do |x|
    res = eval(x)
    while res > 9
      val = x.scan(/num\[\d+\]/)[1]
      eval("#{val} -= 1")
      res = eval(x)
    end
  end
  num.join.to_i
end

def find_min(program)
  rules = find_rules(program)
  num = [1] * 14
  rules.each do |x|
    res = eval(x)
    while res < 1
      val = x.scan(/num\[\d+\]/)[1]
      eval("#{val} += 1")
      res = eval(x)
    end
  end
  num.join.to_i
end

max = find_max(program)
min = find_min(program)

puts max if run_program(program, max.digits).zero?
puts min if run_program(program, min.digits).zero?
