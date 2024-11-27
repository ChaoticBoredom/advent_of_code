require_relative "../../aoc_input"

input = get_input(2015, 15).split("\n")

def parse_input(input)
  list = input.map do |l|
    /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/.match(l).captures
  end
  list.to_h { |k, *args| [k, args.map(&:to_i)] }
end

def get_totals(ingredients, check_calories: false)
  ingredients.keys.repeated_combination(100).map do |keys|
    values = keys.
      tally.
      map { |k, v| ingredients[k].map { |t| t * v } }.
      transpose.
      map(&:sum)

    next if values.any?(&:negative?)
    next if check_calories && values[4] != 500

    values[0..3].inject(:*)
  end
end

ingredients = parse_input(input)

puts get_totals(ingredients).compact.max
puts get_totals(ingredients, check_calories: true).compact.max
