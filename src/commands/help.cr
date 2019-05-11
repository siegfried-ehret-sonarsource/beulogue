module Beulogue
  module Commands
    class Help
      def self.run
        Beulogue.logger.info <<-HELP
          beulogue [<command>]

          Commands:
              build     - Build the site in the current working directory (default command)
              version   - Print the current version of beulogue.

          Options:
              --debug   - Show logs

          More info: https://github.com/SiegfriedEhret/beulogue/
          HELP

        exit
      end
    end
  end
end
