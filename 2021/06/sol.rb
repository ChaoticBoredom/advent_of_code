require_relative "../../aoc_input"

input = get_input(2021, 6).split(",").map(&:to_i)

fish = input.tally

def spawn_fish(fish)
  new_fish = Hash.new(0)
  fish.each do |k, v|
    if (k - 1).negative?
      new_fish[6] += v
      new_fish[8] += v
    else
      new_fish[k - 1] += v
    end
  end
  new_fish
end

def run_sim(input, iter)
  fish = input.tally
  iter.times do
    fish = spawn_fish(fish)
  end
  fish
end

puts run_sim(input, 80).values.sum

puts run_sim(input, 256).values.sum
