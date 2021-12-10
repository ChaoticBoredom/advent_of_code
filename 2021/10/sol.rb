require_relative "../../aoc_input"

input = get_input(2021, 10).split("\n").map(&:chars)

PAIRS = {
  "{" => "}",
  "(" => ")",
  "<" => ">",
  "[" => "]",
}

SCORES = {
  "(" => 1,
  "[" => 2,
  "{" => 3,
  "<" => 4,
}

def line_valid?(line)
  open_brackets = []
  line.each.with_index do |c, idx|
    next if (idx + 1) < line.count && line[idx + 1] == PAIRS[c]
    next if PAIRS[line[idx - 1]] == c
    
    if PAIRS[open_brackets.last] == c
      open_brackets.pop
      next
    end

    open_brackets << c
  end
  [
    open_brackets,
    open_brackets.reject { |x| PAIRS.keys.include?(x) }.first,
  ]
end

def pt1_score(chars)
  h = chars.tally

  h[")"] * 3 +
    h["]"] * 57 +
    h["}"] * 1197 +
    h[">"] * 25137
end

def pt2_score(chars)
  total_score = 0
  chars.reverse.each do |x|
    total_score *= 5
    total_score += SCORES[x]
  end
  total_score
end

bad_chars = []
good_input = []
ob = []
input.each do |line|
  open_brackets, b = line_valid?(line)
  if b.nil?
    good_input << line
    ob << open_brackets
  else
    bad_chars << b
  end
end


puts pt1_score(bad_chars)

scores = ob.map { |x| pt2_score(x) }.sort
puts scores[scores.size/2]
