require_relative "../../aoc_input"

input = get_input(2015, 15).split("\n")

def parse_input(input)
  list = input.map do |l|
    /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/.match(l).captures
  end
  list.to_h { |k, *args| [k, args.map(&:to_i)] }
end

def get_totals(ingredients, check_calories: false)
  options = ingredients.keys.repeated_combination(100)
  options.map do |keys|
    ingredient_values = []
    keys.tally.each do |k, v|
      ingredient_values << ingredients[k].map { |t| t * v }
    end
    values = ingredient_values.transpose.map(&:sum)

    next if values.any?(&:negative?)
    next if check_calories && values[4] != 500

    values[0..3].inject(:*)
  end
end

ingredients = parse_input(input)

puts get_totals(ingredients).compact.max
puts get_totals(ingredients, check_calories: true).compact.max
