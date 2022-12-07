require_relative "../../aoc_input"

input = get_input(2022, 7).split("$")

class Directory
  attr_reader :name, :parent, :directories

  def initialize(parent, name)
    @parent = parent
    @name = name
    @directories = []
    @file_sizes = []
  end

  def add_file(file_size)
    @file_sizes |= [file_size.to_i]
  end

  def add_dir(dir)
    @directories |= [dir]
  end

  def get_dir(name)
    @directories.select { |x| x.name == name }.first
  end

  def total_size
    @file_sizes.sum + @directories.sum(&:total_size)
  end

  def inspect
    "<@name=\"#{@name}\", @parent=\"#{@parent&.name}\", @directories=#{@directories}, @file_sizes=#{@file_sizes}>"
  end
end

def navigate(line, top_dir, curr_dir)
  dir = line.match(/cd (.+)/)
  return curr_dir unless dir

  case dir[1]
  when "/"
    top_dir
  when ".."
    curr_dir.parent
  else
    curr_dir.get_dir(dir[1])
  end
end

def map_ls(line, curr_dir)
  line.split("\n").each do |list_line|
    md = list_line.match(/dir (.*)/)
    curr_dir.add_dir(Directory.new(curr_dir, md[1])) if md
    md = list_line.match(/(\d+) .*/)
    curr_dir.add_file(md[1]) if md
  end
end

def map_directory(input)
  top_dir = Directory.new(nil, "/")
  curr_dir = nil
  input.each do |line|
    curr_dir = navigate(line, top_dir, curr_dir)
    next unless line.match(/ls\n/)

    map_ls(line, curr_dir)
  end

  top_dir
end

def sum_directories(top_dir, max_size)
  top_dir.directories.select { |d| d.total_size <= max_size }.map(&:total_size).sum +
    top_dir.directories.map { |d| sum_directories(d, max_size) }.sum
end

def find_smallest_over(top_dir, size)
  current_candidate = top_dir
  return if top_dir.total_size < size

  top_dir.directories.each do |d|
    current_candidate = d if d.total_size.between?(size, current_candidate.total_size - 1)
    next_smallest = find_smallest_over(d, size)
    next if next_smallest.nil?

    current_candidate = next_smallest if next_smallest.total_size < current_candidate.total_size
  end
  current_candidate
end

dir_map = map_directory(input)
puts sum_directories(dir_map, 100_000)

needed = 70_000_000 - dir_map.total_size
min_to_free = 30_000_000 - needed
puts find_smallest_over(dir_map, min_to_free).total_size
