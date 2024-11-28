require "fileutils"
require "time"
require "open-uri"
require "pry-byebug"

def self.source_root
  File.expand_path("./", File.dirname(__FILE__))
end

def get_input(year, day)
  day_s = day.to_s.rjust(2, "0")
  dir = "#{source_root}/#{year}/#{day_s}"
  file_path = "#{dir}/input.txt"
  FileUtils.mkdir_p(dir)
  input = ""
  if File.file?(file_path) && !File.zero?(file_path)
    File.open(file_path, "r") { |f| input = f.read }
  else
    File.open(file_path, "a+") do |f|
      input = URI.open("https://adventofcode.com/#{year}/day/#{day}/input", headers).read
      f.write(input)
      input
    end
  end

  input
rescue OpenURI::HTTPError
  "Error fetching input"
end

def parse_input_as_hash_of_symbols(input)
  h = {}
  input.split("\n").each.with_index do |l, y|
    l.chars.each.with_index do |c, x|
      h[[x, y]] = c
    end
  end
  h
end

def headers
  @headers ||= {
    "Cookie" => ENV.fetch("COOKIE") { File.read("#{source_root}/.session/cookie").strip },
  }
end

if __FILE__ == $PROGRAM_NAME
  year, day = *ARGV

  year ||= Time.now.getlocal("-05:00").year.to_s
  day ||= Time.now.getlocal("-05:00").day
  get_input(year, day)
end
