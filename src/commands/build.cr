require "../lib/conf"
require "../lib/processor"

module Beulogue
  module Commands
    class Build
      def self.run(path : String)
        config = Conf.load(path)

        if config.nil?
          Beulogue.logger.fatal "Failed to read configuration, exiting."

          exit
        end

        Beulogue.logger.info "Building site: «#{config.title}»"

        processor = Processor.new(path, config)
        processor.run
      end
    end
  end
end
