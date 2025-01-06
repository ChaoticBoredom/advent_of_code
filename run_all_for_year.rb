require "benchmark"
require "rbconfig"
require "rainbow/refinement"

RUBY = File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])

using Rainbow

def format_time(sec)
  time_string = format("%<minutes>02d:%<seconds>08.5f", { :minutes => sec / 60 % 60, :seconds => sec % 60 })
  if sec < 5
    time_string.green
  elsif sec.between?(5, 60)
    time_string.yellow
  elsif sec.between?(60, 120)
    time_string.red
  else
    time_string.red.bright
  end
end

def get_sol_file(year, day_string)
  file_path = "#{__dir__}/#{year}/#{day_string}/sol.rb"
  return file_path if File.file?(file_path)

  print "SOLUTION NOT FOUND".green.bright.bg(:red).blink, "\n\n"
  nil
end

puts "YEAR\tDAY\t\tTIME".bold

ARGF.argv.each do |year|
  (1..25).each do |day|
    day_string = day.to_s.rjust(2, "0")
    results = nil
    print year.red, "\t", day_string.green, "\t\t"
    file_path = get_sol_file(year, day_string)
    next unless file_path

    timing = Benchmark.measure do
      results = `#{RUBY} #{file_path}`
    end

    puts format_time(timing.real)

    puts results, "\n"
  end
end
