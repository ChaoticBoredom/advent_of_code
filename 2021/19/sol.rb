require_relative "../../aoc_input"

input = get_input(2021, 19).split("\n\n")

def distance(loc1, loc2)
  Math.sqrt(
    [
      (loc1[0] - loc2[0])**2,
      (loc1[1] - loc2[1])**2,
      (loc1[2] - loc2[2])**2,
    ].sum
  )
end

def calc_distances(scanner)
  scanner.each do |k, v|
    v[:distances] = []
    scanner.each do |k2, v2|
      next if k == k2

      new_distance = distance(v[:loc], v2[:loc])
      v[:distances] += [new_distance] unless v[:distances].include?(new_distance)
    end
  end
end

def build_fingerprints(input)
  data = {}
  input.each do |scanner|
    beacons = scanner.split("\n")
    current_scanner = beacons.shift.match(/(\d+)/)[1].to_i
    mapped_scanner = {}
    beacons.each.with_index do |beacon, idx|
      mapped_scanner[idx] = { :loc => beacon.split(",").map(&:to_i) }
    end
    calc_distances(mapped_scanner)
    data[current_scanner] = mapped_scanner
  end
  data
end

def find_matching_beacons(scanners)
  matches = []
  scanners.each do |k1, v1|
    scanners.each do |k2, v2|
      next if k1 >= k2

      v1.each do |b1, d1|
        v2.each do |b2, d2|
          next unless (d1[:distances] & d2[:distances]).count >= 11

          matches << { :s1 => k1, :s2 => k2, :b1 => b1, :b2 => b2 }
          return matches if matches.count == 12
        end
      end
    end
  end
  matches
end

def find_offset(matches, fingerprints)
  offsets = []
  matches.each_cons(2) do |match_hash1, match_hash2|
    next unless match_hash1[:s1] == match_hash2[:s1]
    next unless match_hash1[:s2] == match_hash2[:s2]

    s1_beacon1 = fingerprints[match_hash1[:s1]][match_hash1[:b1]]
    s1_beacon2 = fingerprints[match_hash2[:s1]][match_hash2[:b1]]
    s2_beacon1 = fingerprints[match_hash1[:s2]][match_hash1[:b2]]
    s2_beacon2 = fingerprints[match_hash2[:s2]][match_hash2[:b2]]
    s1_diff = s1_beacon1[:loc].zip(s1_beacon2[:loc]).map { |x| x.inject(:-) }
    s2_diff = s2_beacon1[:loc].zip(s2_beacon2[:loc]).map { |x| x.inject(:-) }
    next if s2_diff.any?(&:zero?)

    s2_idx = s1_diff.map { |x| s2_diff.index(x) || s2_diff.index(-x) }
    s2_orientation = s1_diff.map.with_index { |x, idx| x / s2_diff[s2_idx[idx]] }
    offset = s1_beacon1[:loc].map.with_index { |x, idx| x - (s2_beacon1[:loc][s2_idx[idx]] * s2_orientation[idx]) }
    offsets << {
      :s1 => match_hash1[:s1],
      :s2 => match_hash1[:s2],
      :offset => offset,
      :idx => s2_idx,
      :orient => s2_orientation,
    }
  end
  offsets.uniq.first if offsets.uniq.count == 1
end

def move_beacons(fingerprints, scanner, offsets)
  known_beacons = fingerprints[offsets[:s1]].map { |_, v| v[:loc] }

  fingerprints[scanner].each do |_, beacon|
    loc = beacon[:loc]
    resolved_loc = 0.upto(2).map do |x|
      loc[offsets[:idx][x]] * offsets[:orient][x] + offsets[:offset][x]
    end

    unless known_beacons.include?(resolved_loc)
      max_id = fingerprints[offsets[:s1]].keys.max
      fingerprints[offsets[:s1]][max_id + 1] = { :loc => resolved_loc }
    end
  end
  calc_distances(fingerprints[offsets[:s1]])
end

def find_greatest_distance(offsets)
  max_distance = 0
  offsets.combination(2).each do |h1, h2|
    distance = 0.upto(2).map { |x| (h1[:offset][x] - h2[:offset][x]).abs }.sum
    max_distance = distance if max_distance < distance
  end
  max_distance
end

fingerprints = build_fingerprints(input)
offsets = []
while fingerprints.size > 1
  matches = find_matching_beacons(fingerprints)
  offset = find_offset(matches, fingerprints)
  target_scanner = matches.map { |x| x[:s2] }.uniq.first
  move_beacons(fingerprints, target_scanner, offset)
  offsets << offset
  fingerprints.delete(target_scanner)
end

puts fingerprints[0].count
puts find_greatest_distance(offsets)
