require_relative "../../aoc_input"

input = get_input(2022, 11).split("\n\n")

class Monkey
  attr_accessor :current, :true_target, :false_target, :test, :operation
  attr_reader :counted

  def initialize(lines)
    @counted = 0
    lines.split("\n").each do |t|
      case t
      when /Starting items:/
        items = /Starting items: (.*)/.match(t)[1]
        @current = items.split(", ").map(&:to_i)
      when /Operation:/
        @operation = /Operation: (.*)/.match(t)[1]
      when /Test:/
        @test = /(\d+)/.match(t)[1].to_i
      when /true/
        @true_target = /(\d+)/.match(t)[1].to_i
      when /false/
        @false_target = /(\d+)/.match(t)[1].to_i
      end
    end
  end

  def catch_tossed(item)
    @current << item
  end

  def inspect_items(monkey_hash, worry, mod)
    @current.delete_if do |item|
      item = my_operation(item)
      item /= 3 if worry
      item = item % mod
      @counted += 1
      target = (item % @test).zero? ? @true_target : @false_target
      monkey_hash[target].catch_tossed(item)
      true
    end
  end

  def inspect
    "<@counted=#{@counted}, @current=#{@current}>"
  end

  private

  def my_operation(old)
    eval(@operation)
  end
end

def parse_monkeys(m)
  h = {}
  m.map.with_index do |line, idx|
    h[idx] = Monkey.new(line)
  end
  h
end

def run_monkeys(m, count, worry_divide)
  mod = m.values.map(&:test).reduce(1, :lcm)
  count.times do
    m.each_key do |k|
      m[k].inspect_items(m, worry_divide, mod)
    end
  end
end

monkeys = parse_monkeys(input)
run_monkeys(monkeys, 20, true)
puts monkeys.map { |_, v| v.counted }.max(2).inject(:*)

monkeys = parse_monkeys(input)
run_monkeys(monkeys, 10_000, false)
puts monkeys.map { |_, v| v.counted }.max(2).inject(:*)
