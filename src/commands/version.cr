module Beulogue
  module Commands
    class Version
      def self.run
        Beulogue.logger.info "beulogue v#{VERSION}"

        exit
      end
    end
  end
end
