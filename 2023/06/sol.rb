require_relative "../../aoc_input"

input = get_input(2023, 6).split("\n")

times = input[0].scan(/\d+/).map(&:to_i)
distances = input[1].scan(/\d+/).map(&:to_i)

def calc_winning_attempts(time, distance)
  winners = []
  0.upto(time).each do |dur|
    move_time = time - dur
    winners << dur if (move_time * dur) > distance
  end

  winners
end

win_counts = []
times.count.times do |i|
  race_time = times[i]
  record_distance = distances[i]
  result = calc_winning_attempts(race_time, record_distance)
  win_counts << result.count
end

puts win_counts.inject(:*)

pt_2_time = input[0].scan(/\d+/).join.to_i
pt_2_distance = input[1].scan(/\d+/).join.to_i

result = calc_winning_attempts(pt_2_time, pt_2_distance)
puts result.count
