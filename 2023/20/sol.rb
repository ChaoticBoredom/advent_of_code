require_relative "../../aoc_input"

input = get_input(2023, 20).split("\n")

LOW = 0
HI = 1

OFF = false
ON = true

@modules = {}
@mod_type = {}
@flip_flops = {}
@con_mem = {}

def parse_input(input)
  input.each do |line|
    mod, handoffs = line.split(" -> ")
    type, mod = mod.match(/(%|&)?(\w+)/).captures
    @modules[mod] = handoffs.split(", ")
    @flip_flops[mod] = OFF if type == "%"
    @con_mem[mod] = {} if type == "&"
  end
  reverse_traverse_cons
end

def reverse_traverse_cons
  @con_mem.each_key do |con|
    @modules.select { |_, v| v.include?(con) }.each_key do |k|
      @con_mem[con][k] = LOW
    end
  end
end

def flip_flop(signal, mod)
  return if signal == HI

  pulse = @flip_flops[mod]
  @flip_flops[mod] = !pulse
  pulse == OFF ? HI : LOW
end

def conjunction(signal, mod, prev)
  mem = @con_mem[mod]
  if mem == LOW
    @con_mem[mod] = { prev => signal }
  else
    @con_mem[mod][prev] = signal
  end

  @con_mem[mod].values.all? { |x| x == HI } ? LOW : HI
end

def send_signal(signal, mod, prev)
  new_sig = flip_flop(signal, mod) if @flip_flops.key?(mod)
  new_sig = conjunction(signal, mod, prev) if @con_mem.key?(mod)

  nm = @modules[mod]

  [nm, new_sig] unless new_sig.nil? || nm.nil?
end

def check_rx_input(mod, signal)
  return unless @watchers.keys.include?(mod)
  return unless signal == LOW
  return unless @watchers[mod].zero?

  @watchers[mod] = @loop_count
end

def push_button(break_on_rx = false)
  signal = LOW
  low_count = 1
  hi_count = 0
  prev = "broadcaster"
  next_modules = [[@modules[prev], signal, prev]]
  until next_modules.empty?
    mods, signal, prev = next_modules.shift
    mods.each do |m|
      low_count += 1 if signal == LOW
      hi_count += 1 if signal == HI
      check_rx_input(m, signal) if break_on_rx
      return if break_on_rx && @watchers.all? { |_, v| v.positive? }

      nm, new_sig = send_signal(signal, m, prev)
      next_modules << [nm, new_sig, m] unless nm.nil? || new_sig.nil?
    end
  end
  [low_count, hi_count]
end

def prep_part_two
  reverse_traverse_cons
  @flip_flops.transform_values! { OFF }
  mod = @modules.select { |_, v| v.include?("rx") }.keys.first
  @watchers = @con_mem[mod].dup
end

parse_input(input)

puts 1000.times.map { push_button }.transpose.map(&:sum).inject(:*)

prep_part_two
@loop_count = 0
Kernel.loop do
  @loop_count += 1
  break if push_button(true).nil?
end
puts @watchers.values.reduce(1, :lcm)
