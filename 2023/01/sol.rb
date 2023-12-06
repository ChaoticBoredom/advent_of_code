require_relative "../../aoc_input"

input = get_input(2023, 1).split("\n")

puts input.map { |val| val.scan(/\d/).values_at(0, -1).join.to_i }.sum

sub_list = {
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9",
}

rx = Regexp.new("(?=(\\d|" + sub_list.keys.join("|") + "))")

x = input.map do |val|
  val.scan(rx).flatten.map { |v| sub_list.key?(v) ? sub_list[v] : v }.values_at(0, -1).join.to_i
end

puts x.sum
