require_relative "../../aoc_input"

input = get_input(2021, 13).split("\n")

instructions = input.select { |x| x.include?("fold along") }
dots = input.select { |x| x.include?(",") }.map { |x| x.split(",").map(&:to_i) }

def print_dots(dots)
  0.upto(dots.map(&:last).max) do |y|
    0.upto(dots.map(&:first).max) do |x|
      if dots.include?([x, y])
        print "#"
      else
        print "."
      end
    end
    print "\n"
  end
end

def calc_new_location(val, fold_line)
  diff = val - fold_line
  return fold_line - diff if diff.positive?

  val
end

def fold(dots, fold_line, fold_dir)
  dots.map do |x, y|
    new_x = calc_new_location(x, fold_line) if fold_dir == "x"
    new_y = calc_new_location(y, fold_line) if fold_dir == "y"

    [new_x || x, new_y || y]
  end
end

dir, loc = instructions.first.split("=")
dir = dir.split.pop

puts fold(dots, loc.to_i, dir).uniq.count

instructions.each do |x|
  dir, loc = x.split("=")
  dir = dir.split.pop

  dots = fold(dots, loc.to_i, dir).uniq
end

print_dots(dots)
