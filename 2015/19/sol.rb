require_relative "../../aoc_input"

input = get_input(2015, 19).split("\n")

original_molecule = input.pop
molecule_hash = {}
input.
  compact.
  reject!(&:empty?).
  map { |v| v.split(" => ") }.each do |k, v|
    molecule_hash[k] = [] unless molecule_hash.key?(k)
    molecule_hash[k] << v
  end

def replace_molecules(conversion_hash, molecule)
  new_molecules = []
  conversion_hash.each do |element, replacements|
    molecule.enum_for(:scan, /#{element}/).map { Regexp.last_match.begin(0) }.each do |index|
      replacements.each do |new_element|
        temp = molecule.dup
        temp[index...(index + element.length)] = new_element
        new_molecules << temp
      end
    end
  end
  new_molecules
end

def build_molecule(conversion_hash, molecule)
  new_hash = {}
  conversion_hash.each { |k, v| v.each { |sub_v| new_hash[sub_v] = k } }
  count = 0
  original_molecule = molecule.dup
  new_hash = new_hash.sort_by { |k, _| k.length }.reverse
  while molecule.length > 1
    new_hash.each do |k, v|
      next unless molecule.include?(k)

      molecule.sub!(/#{k}/, v)
      count += 1
      break
    end
    return count if molecule == "e"
    next if new_hash.map(&:first).any? { |k| molecule.include?(k) }

    # RESET
    molecule = original_molecule.dup
    count = 0
    new_hash.shuffle!
  end
  count
end

puts replace_molecules(molecule_hash, original_molecule).uniq.count
puts build_molecule(molecule_hash, original_molecule)
