require_relative "../../aoc_input"

input = get_input(2015, 14).split("\n")

def parse_input(input)
  input.map { |l| /(\w+) .* (\d+) .* (\d+) .* (\d+) seconds./.match(l).captures }.
    to_h { |k, s, ft, rt| [k, [s.to_i, ft.to_i, rt.to_i]] }
end

def run_old_school_race(time, deer)
  deer.map do |k, v|
    speed, fly_time, rest_time = v
    movement = speed * fly_time
    cycles = time / (fly_time + rest_time)
    remaining = time % (fly_time + rest_time)
    distance = cycles * movement
    distance += remaining >= fly_time ? movement : speed * remaining
    [k, distance]
  end
end

def run_new_race(time, deer)
  deer_tally = deer.to_h { |k, _| [k, 0] }
  (1..time).each do |i|
    point_getter = run_old_school_race(i, deer).group_by { |v| v[1] }.max[1].map { |v| v[0] }
    point_getter.each { |pg| deer_tally[pg] += 1 }
  end
  deer_tally
end

deer = parse_input(input)
puts(run_old_school_race(2503, deer).max_by { |v| v[1] })
puts(run_new_race(2503, deer).max_by { |_, v| v })
