require_relative "../../aoc_input"

input = get_input(2015, 25)

row = /row (\d+)/.match(input)[1].to_i
column = /column (\d+)/.match(input)[1].to_i

n = (row + column - 2)
iterations = (n * (n + 1)) / 2
iterations += column - 1

def get_next_val(code)
  (code * 252_533) % 33_554_393
end

val = 20_151_125
iterations.times do
  val = get_next_val(val)
end
puts val