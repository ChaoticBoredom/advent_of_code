require_relative "../../aoc_input"

input = get_input(2022, 20).chomp.split("\n")

class Node
  attr_accessor :prev, :next, :value

  def initialize(value)
    @value = value
  end
end

def create_linked_list(vals, key)
  list = vals.map { |v| Node.new(v.to_i * key) }
  list.each_cons(2) do |a, b|
    a.next = b
    b.prev = a
  end
  list.last.next = list.first
  list.first.prev = list.last
  list
end

def mix(list)
  list.each do |x|
    x.prev.next = x.next
    x.next.prev = x.prev
    a = x.prev
    b = x.next
    new_idx = x.value % (list.count - 1)

    new_idx.times do
      a = a.next
      b = b.next
    end

    a.next = x
    x.prev = a
    b.prev = x
    x.next = b
  end
end

def solve(list)
  val = list.select { |x| x.value.zero? }.first
  total = 0

  3.times do
    1000.times { val = val.next }
    total += val.value
  end

  total
end

list = create_linked_list(input, 1)
mix(list)
puts solve(list)

list2 = create_linked_list(input, 811589153)
10.times { mix(list2) }
puts solve(list2)
