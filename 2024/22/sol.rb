require_relative "../../aoc_input"

input = get_input(2024, 22).split("\n").map(&:to_i)

def gen_number(num)
  num = (num ^ num * 64) % 16_777_216
  num = (num ^ (num / 32.0).floor) % 16_777_216
  (num ^ num * 2048) % 16_777_216
end

def get_secrets(input)
  buyers = input.map.with_index { |v, i| [i, [v]] }.to_h
  buyers.each_key { |bid| 2000.times { buyers[bid] += [gen_number(buyers[bid].last)] } }
  buyers
end

def build_new_hash(buyers)
  seq_hash = {}
  buyers.each do |i, nums|
    nums.each_cons(2).map { |a, b| b.digits.first - a.digits.first }.
      each_cons(4).with_index { |s, j| seq_hash[s + [i]] ||= nums[j + 4].digits.first }
  end
  seq_hash
end

def find_most_bananas(buyers)
  seq_hash = build_new_hash(buyers)

  most_bananas = Hash.new(0)
  seq_hash.each { |k, v| most_bananas[k.first(4)] += v }
  most_bananas.values.max
end

buyers = get_secrets(input)

puts buyers.values.map(&:last).sum
puts find_most_bananas(buyers)
