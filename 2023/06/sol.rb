require_relative "../../aoc_input"

input = get_input(2023, 6).split("\n")

def calc_winning_attempts(time, distance)
  winners = []
  0.upto(time).each do |dur|
    move_time = time - dur
    winners << dur if (move_time * dur) > distance
  end

  winners
end

times = input[0].scan(/\d+/).map(&:to_i)
distances = input[1].scan(/\d+/).map(&:to_i)

races = times.zip(distances)

win_counts = races.map { |time, distance| calc_winning_attempts(time, distance).count }

puts win_counts.inject(:*)

pt_2_time = input[0].scan(/\d+/).join.to_i
pt_2_distance = input[1].scan(/\d+/).join.to_i

result = calc_winning_attempts(pt_2_time, pt_2_distance)
puts result.count
