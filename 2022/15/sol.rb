require_relative "../../aoc_input"

input = get_input(2022, 15).chomp.split("\n")

def parse_input(input)
  s_data = input.match(/Sensor at x=(-?\d+), y=(-?\d+)/)
  b_data = input.match(/is at x=(-?\d+), y=(-?\d+)/)
  sensor = [s_data[1].to_i, s_data[2].to_i]
  beacon = [b_data[1].to_i, b_data[2].to_i]
  sensor_range = get_range(sensor, beacon)
  [sensor, sensor_range, beacon]
end

def get_range(sensor, beacon)
  (sensor[0] - beacon[0]).abs +
    (sensor[1] - beacon[1]).abs
end

def get_row_width(sensor, row, range)
  range - (sensor[1] - row).abs
end

def find_overlaps(row, sensors)
  covered_range = []
  sensors.each do |loc, range|
    next unless row.between?(loc[1] - range, loc[1] + range)

    row_length = get_row_width(loc, row, range)
    row_min = loc[0] - row_length
    row_max = loc[0] + row_length
    covered_range += (row_min..row_max).to_a
  end
  covered_range
end

def find_distress_signal(sensors)
  sensors.each do |loc, range|
    (0..range + 1).each do |val|
      [[loc[0] - range - 1 + val, loc[1] - val],
       [loc[0] + range + 1 - val, loc[1] - val],
       [loc[0] - range - 1 + val, loc[1] + val],
       [loc[0] + range + 1 - val, loc[1] + val]].each do |tx, ty|
         next unless tx.between?(0, 4_000_000)
         next unless ty.between?(0, 4_000_000)
         next unless sensors.map { |l2, r2| (tx - l2[0]).abs + (ty - l2[1]).abs > r2 }.all?

         return [tx, ty]
       end
    end
  end
end

sensors = {}
beacons = []
input.each do |line|
  s, r, b = parse_input(line)
  sensors[s] = r
  beacons << b
end

puts find_overlaps(2_000_000, sensors).uniq.count - beacons.uniq.count { |x| x[1] == 2_000_000 }

res = find_distress_signal(sensors)
puts res[0] * 4_000_000 + res[1]
