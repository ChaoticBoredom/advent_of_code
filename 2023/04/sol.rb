require_relative "../../aoc_input"

input = get_input(2023, 4).split("\n")

def count_cards(input)
  winners = []
  input.each do |card|
    nums = get_card_numbers(card)
    (nums.count > 0) ? winners << (2 ** (nums.count - 1)) : winners << 0
  end
  winners.sum
end

def recurse_cards(input)
  total_counts = Hash[input.join.scan(/(\d+):/).flatten.map(&:to_i).map { |v| [v, 1] }]

  input.each do |card|
    md = /Card *(\d+): /.match(card)
    card_id = md.captures.first.to_i
    total_counts[card_id] ||= 1  
    current_count = total_counts[card_id]
    card_counts = get_card_numbers(card)
    card_counts.count.times do
      card_id += 1
      total_counts[card_id] = (total_counts[card_id] || 0) + current_count
    end
  end

  total_counts.values.sum
end

def get_card_numbers(card)
  start = card.index(":")
  split = card.index("|")

  winning_numbers = card[(start + 1)..(split - 1)].split(" ").map(&:to_i)
  player_numbers = card[(split + 1)..-1].split(" ").map(&:to_i)
  
  winning_numbers & player_numbers
end
  
puts count_cards(input)

puts recurse_cards(input)
