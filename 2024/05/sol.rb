require_relative "../../aoc_input"

input = get_input(2024, 5)

ordering_rules, updates = input.split("\n\n")

updates = updates.split("\n").map { |x| x.split(",").map(&:to_i) }

def create_preceeding_hash(ordering_rules)
  ordering_rules = ordering_rules.split("\n").map { |x| x.split("|").map(&:to_i) }
  preceeding_hash = Hash.new([])
  ordering_rules.each do |x, y|
    preceeding_hash[x] += [y]
  end

  preceeding_hash
end

def update_valid?(update, preceeding_hash)
  update.each.with_index do |val, i|
    following_pages = update.drop(i + 1)
    arr = preceeding_hash[val]

    return false unless following_pages.count == arr.intersection(following_pages).count
  end
end

def find_middle_printed_values(values)
  values.map do |x|
    middle = x.count / 2
    x[middle]
  end
end

def fix_invalid_update(updates, preceeding_hash)
  updates.sort_by { |x| preceeding_hash[x].intersection(updates).count }
end

preceeding_hash = create_preceeding_hash(ordering_rules)

valid_updates, invalid_updates = updates.partition { |x| update_valid?(x, preceeding_hash) }

puts find_middle_printed_values(valid_updates).sum

fixed_invalid_updates = invalid_updates.map { |x| fix_invalid_update(x, preceeding_hash) }
puts find_middle_printed_values(fixed_invalid_updates).sum
