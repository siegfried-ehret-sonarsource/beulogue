require "./lib/conf"
require "./lib/processor"

# TODO: Write documentation for `Beulogue`
module Beulogue
  VERSION = "0.1.0"

  # TODO: Put your code here
  cwd = Dir.current
  puts "Running in " + cwd

  config = Conf.load(cwd)
  if config.nil?
    puts "Failed to read configuration, exiting."
    Process.exit
  end

  puts "Building site: " + config.title

  processor = Processor.new(cwd, config)
  processor.run
end
