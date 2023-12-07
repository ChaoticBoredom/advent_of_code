require_relative "../../aoc_input"

input = get_input(2023, 7).split("\n")

SUBS = {
  "T" => 10,
  "J" => 11,
  "Q" => 12,
  "K" => 13,
  "A" => 14,
}.freeze

SUBS2 = {
  "T" => 10,
  "J" => 1,
  "Q" => 12,
  "K" => 13,
  "A" => 14,
}.freeze

h = {}

input.each do |line|
  hand, bid = line.split(" ")
  h[hand] = bid
end

def sort_method(first, second)
  ft = first.split("").tally
  st = second.split("").tally
  return ft.values.max(2) <=> st.values.max(2) if ft.values.max(2) != st.values.max(2)

  first.split("").zip(second.split("")).each do |f, s|
    next if f == s

    return SUBS.fetch(f, f).to_i <=> SUBS.fetch(s, s).to_i
  end
end

def get_tally_counts(tally_count)
  j_val = tally_count.delete("J") || 0
  max_array = tally_count.values.max(2)
  max_array << 0 while max_array.count < 2

  max_array.zip([j_val, 0]).map(&:sum)
end

def second_sort_method(first, second)
  ft = first.split("").tally
  st = second.split("").tally

  max_ft_values = get_tally_counts(ft)
  max_st_values = get_tally_counts(st)
  return max_ft_values <=> max_st_values if max_ft_values != max_st_values

  first.split("").zip(second.split("")).each do |f, s|
    next if f == s

    return SUBS2.fetch(f, f).to_i <=> SUBS2.fetch(s, s).to_i
  end
end

def tally_ranks_and_bids(sorted, bids)
  total = 0
  sorted.each.with_index(1) do |hand, i|
    total += i * bids[hand].to_i
  end
  total
end

sorted = h.keys.sort { |x, y| sort_method(x, y) }
second_sorted = h.keys.sort { |x, y| second_sort_method(x, y) }

puts tally_ranks_and_bids(sorted, h)
puts tally_ranks_and_bids(second_sorted, h)
