require_relative "../../aoc_input"

input = get_input(2023, 15).chomp.split("\,")

def convert_hash(str)
  curr_val = 0
  str.chars.each do |c|
    curr_val = ((curr_val + c.ord) * 17) % 256
  end
  curr_val
end

def sort_boxes(str, boxes)
  label, op, foc = str.split(/(=|-)/)
  converted_label = convert_hash(label)
  boxes[converted_label] ||= {}
  boxes[converted_label][label] = foc if op == "="
  boxes[converted_label].delete(label) if op == "-"
end

def sum_focusing(boxes)
  boxes.sum do |k, v|
    mini_total = []

    v.each_value.with_index(1) do |fl, idx|
      mini_total << (k + 1) * idx * fl.to_i
    end
    mini_total.sum
  end
end

total = input.sum { |x| convert_hash(x) }
puts total

boxes = {}
input.each { |x| sort_boxes(x, boxes) }
puts sum_focusing(boxes)
