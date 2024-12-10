require "benchmark"
require "rbconfig"
require "rainbow/refinement"

THIS_FILE = File.expand_path(__FILE__)

RUBY = File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])

using Rainbow

ARGF.argv.each do |year|
  (1..25).each do |day|
    day_string = day.to_s.rjust(2, "0")
    file_path = "#{__dir__}/#{year}/#{day_string}/sol.rb"
    results = nil
    print year.red, "\t", day_string.green, "\t\t"
    timing = Benchmark.measure do
      results = `#{RUBY} #{file_path}`
    end

    if timing.real < 5
      puts timing.real.to_s.green
    elsif timing.real.between?(5, 60)
      puts timing.real.to_s.yellow
    elsif timing.real.between?(60, 120)
      puts timing.real.to_s.red
    else
      puts timing.real.to_s.red.bright
    end

    puts results
  end
end
