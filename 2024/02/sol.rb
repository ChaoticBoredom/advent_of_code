require_relative "../../aoc_input"

input = get_input(2024, 2).split("\n")

report_list = input.map { |x| x.split(" ").map(&:to_i) }

def all_increasing?(report)
  report.each_cons(2).all? { |a, b| (a <=> b) <= 0 }
end

def all_decreasing?(report)
  report.each_cons(2).all? { |a, b| (a <=> b) >= 0 }
end

def differences_within_tolerance?(report)
  report.each_cons(2).all? { |a, b| (a - b).abs >= 1 && (a - b).abs <= 3 }
end

def safe?(report)
  (all_increasing?(report) || all_decreasing?(report)) && differences_within_tolerance?(report)
end

def safe_with_problem_damper?(report)
  report.combination(report.count - 1).map { |r| safe?(r) }.any?
end

puts report_list.select { |r| safe?(r) }.count
puts report_list.select { |r| safe_with_problem_damper?(r) }.count
