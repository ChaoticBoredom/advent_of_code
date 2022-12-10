require_relative "../../aoc_input"

input = get_input(2022, 10).split("\n")

def process_line(line, x, cycle_count, sig_strength, pix_arr)
  op, val = line.split(" ")
  pix_arr = draw_pixels(pix_arr, cycle_count, x)
  case op
  when "noop"
    cycle_count += 1
  when "addx"
    cycle_count += 1
    sig_strength = add_sig_strength(x, cycle_count, sig_strength)
    pix_arr = draw_pixels(pix_arr, cycle_count, x)
    x += val.to_i
    cycle_count += 1
  end
  sig_strength = add_sig_strength(x, cycle_count, sig_strength)
  [x, sig_strength, cycle_count, pix_arr]
end

def add_sig_strength(x, cycle, strength)
  return strength unless (cycle % 20).zero?
  return strength unless ((cycle - 20) % 40).zero?

  strength + x * cycle
end

def draw_pixels(pix_arr, cycle, x)
  calced = cycle
  (calced -= 40 while calced > 40) if cycle > 40
  char = calced.between?(x, x + 2) ? "#" : "."

  pix_arr << char
  pix_arr << "\n" if (cycle % 40).zero?
  pix_arr
end

x = 1
cycle_count = 1
total_signal_strength = 0
pix_arr = []

input.each do |line|
  x, total_signal_strength, cycle_count, pix_arr = process_line(
    line,
    x,
    cycle_count,
    total_signal_strength,
    pix_arr
  )
end

puts total_signal_strength
print pix_arr.join
