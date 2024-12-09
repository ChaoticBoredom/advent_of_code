require_relative "../../aoc_input"

input = get_input(2024, 9)

def parse_input(input)
  h = {}
  input.chars.each_slice(2).with_index do |d, i|
    h[i] = d.map(&:to_i)
  end
  h
end

def convert_blocks(blocks)
  new_blocks = {}
  hash_key_start = 0
  blocks.each do |k, f_data|
    file_size, empty_spaces = f_data
    file_size.times { |i| new_blocks[hash_key_start + i] = k }
    hash_key_start += (file_size || 0) + (empty_spaces || 0)
  end
  new_blocks
end

def shuffle(blocks)
  empty_spaces = (0..blocks.keys.max).to_a - blocks.keys
  until empty_spaces.empty?
    k = blocks.keys.max
    break if k < empty_spaces.first

    val = blocks.delete(k)
    blocks[empty_spaces.shift] = val
  end

  blocks
end

def smart_shuffle(blocks)
  empty_spaces = (0..blocks.keys.max).to_a - blocks.keys
  blocks.values.sort.reverse.uniq.each do |val|
    keys_to_move = blocks.find_all { |_, v| v == val }.map(&:first)

    spaces = find_consecutive(empty_spaces, keys_to_move.count)
    next if spaces.nil?
    next if spaces.first > keys_to_move.first

    val = blocks[keys_to_move.first]
    keys_to_move.each { |k| blocks.delete(k) }
    spaces.each do |k|
      blocks[k] = val
      empty_spaces.delete(k)
    end
  end
  blocks
end

def find_consecutive(arr, consecutive_count)
  arr.each_cons(consecutive_count).each do |b|
    return b if b.each_cons(2).all? { |a, b| b == a + 1 }
  end
end

def get_checksum(blocks)
  blocks.sum { |k, v| k * v }
end

file_blocks = convert_blocks(parse_input(input))

puts get_checksum(shuffle(file_blocks.dup))
puts get_checksum(smart_shuffle(file_blocks.dup))
