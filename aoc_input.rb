require "fileutils"
require "time"
require "open-uri"

def self.source_root
  File.expand_path("./", File.dirname(__FILE__))
end

def get_input(year, day)
  day_s = day.to_s.rjust(2, "0")
  dir = "#{source_root}/#{year.to_s}/#{day_s}"
  file_path = dir + "/input.txt"
  FileUtils.mkdir_p(dir)
  input = ""
  if File.file?(file_path)
    File.open(file_path, "r") do |f|
      input = f.read
    end
  else 
    File.open(file_path, "a+") do |f|
      input = URI.open("https://adventofcode.com/#{year}/day/#{day}/input", headers).read
      f.write(input)
    end
  end

  input
rescue OpenURI::HTTPError
  "Error fetching input"
end

def headers
  @headers ||= { "Cookie" => ENV.fetch("COOKIE") do
    File.read("#{source_root}/.session/cookie").strip 
  end }
end

# Only for command line use, generally not used
# year, day = *ARGV

# year ||= Time.now.getlocal("-05:00").year.to_s
# day ||= Time.now.getlocal("-05:00").day
# get_input(year, day)
