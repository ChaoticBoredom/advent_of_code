require_relative "../../aoc_input"

input = get_input(2015, 16).split("\n")

def parse_input(input)
  sues = {}
  input.each do |l|
    sue_id = /Sue (\d+)/.match(l).captures.first.to_i

    sues[sue_id] = {
      :children => /children: (\d+)/.match(l)&.captures&.first&.to_i,
      :cats => /cats: (\d+)/.match(l)&.captures&.first&.to_i,
      :samoyeds => /samoyeds: (\d+)/.match(l)&.captures&.first&.to_i,
      :pomeranians => /pomeranians: (\d+)/.match(l)&.captures&.first&.to_i,
      :akitas => /akitas: (\d+)/.match(l)&.captures&.first&.to_i,
      :vizslas => /vizslas: (\d+)/.match(l)&.captures&.first&.to_i,
      :goldfish => /goldfish: (\d+)/.match(l)&.captures&.first&.to_i,
      :trees => /trees: (\d+)/.match(l)&.captures&.first&.to_i,
      :cars => /cars: (\d+)/.match(l)&.captures&.first&.to_i,
      :perfumes => /perfumes: (\d+)/.match(l)&.captures&.first&.to_i,
    }
  end
  sues
end

counts = {
  :children => 3,
  :cats => 7,
  :samoyeds => 2,
  :pomeranians => 3,
  :akitas => 0,
  :vizslas => 0,
  :goldfish => 5,
  :trees => 3,
  :cars => 2,
  :perfumes => 1}

def find_sue(sues, counts)
  counts.each.with_index do |(key, value), i|
    sues.select! { |_, v| v[key] == value || v[key].nil? }
  end
  sues
end

def find_sue_2(sues, counts)
  counts.each.with_index do |(key, value), i|
    case key
    when :cats, :trees
      sues.select! { |_, v| v[key].nil? || v[key] > value }
    when :pomeranians, :goldfish
      sues.select! { |_, v| v[key].nil? || v[key] < value }
    else
      sues.select! { |_, v| v[key].nil? || v[key] == value }
    end
  end
  sues
end

puts find_sue(parse_input(input), counts).keys
puts find_sue_2(parse_input(input), counts).keys
