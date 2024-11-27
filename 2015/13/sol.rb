require_relative "../../aoc_input"

input = get_input(2015, 13).split("\n")

def parse_input(input)
  captures = input.map { |l| /(\w+) would (gain|lose) (\d+) .* (\w+)./.match(l).captures }

  happiness_ranks = {}
  captures.each do |name1, change, happiness, name2|
    happiness = happiness.to_i
    happiness *= -1 if change == "lose"
    happiness_ranks[name1] ||= {}
    happiness_ranks[name1][name2] = happiness
  end

  happiness_ranks
end

people = parse_input(input)

def find_happinesses(people)
  people.keys.permutation.map do |p|
    p.each_cons(2).map { |p1, p2| people[p1][p2] + people[p2][p1] }.
      sum + people[p.first][p.last] + people[p.last][p.first]
  end
end

puts find_happinesses(people).max

people.transform_values { |v| v["me"] = 0 }
people["me"] = people.keys.to_h { |k, _| [k, 0] }

puts find_happinesses(people).max
