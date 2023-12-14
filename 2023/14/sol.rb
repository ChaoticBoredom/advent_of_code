require_relative "../../aoc_input"

input = get_input(2023, 14).split("\n")

@map = Hash.new(".")

def build_map(input)
  input.each.with_index do |line, idy|
    line.chars.each.with_index do |c, idx|
      @map[[idx, idy]] = c unless c == "."
    end
  end
end

def max_values
  @max ||= @map.keys.transpose.map(&:max)
  [@max[0], @max[1]]
end

def print_map
  max_x, max_y = max_values
  0.upto(max_y) do |y|
    0.upto(max_x) do |x|
      print @map[[x, y]]
    end
    print "\n"
  end
end

def north_south(range, check, final)
  range do |new_y|
    if @map.key?([x, new_y].zip(check).map(&:sum))
      @map.delete([x, y])
      @map[[x, new_y]] = "O"
      return
    end
  end
  @map.delete([x, y])
  @map[[x, final]] = "O"
end

def move_north(x, y)
  y.downto(0) do |new_y|
    if @map.key?([x, new_y - 1])
      @map.delete([x, y])
      @map[[x, new_y]] = "O"
      return
    end
  end
  @map.delete([x, y])
  @map[[x, 0]] = "O"
end

def move_south(x, y)
  max_x, max_y = max_values
  y.upto(max_y) do |new_y|
    if @map.key?([x, new_y + 1])
      @map.delete([x, y])
      @map[[x, new_y]] = "O"
      return
    end
  end
  @map.delete([x, y])
  @map[[x, max_y]] = "O"
end

def roll(dir)
  round_stones = @map.select { |_, v| v == "O" }

  round_stones.each_key do |x, y|
    move_north(x, y) if dir == "N"
    move_south(x, y) if dir == "S"
    move_west(x, y) if dir == "W"
    move_east(x, y) if dir == "E"
  end
end

def calc_load
  _, max_y = @map.keys.transpose.map(&:max)
  south_end = max_y + 1
  round_stones = @map.select { |_, v| v == "O" }
  total = 0
  round_stones.each_key do |key|
    total += south_end - key[1]
  end
  total
end

def spin
  roll("N")
  roll("W")
  roll("S")
  roll("E")
end

build_map(input)
print_map
roll("N")
print_map
puts calc_load
