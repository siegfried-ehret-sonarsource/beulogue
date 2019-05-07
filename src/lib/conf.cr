require "yaml"

module Beulogue
  module Conf
    def self.load(cwd : String)
      cwdPath = Path[cwd]
      configPath = cwdPath.join("beulogue.yml")
      puts "Reading config at: " + configPath.to_s

      config = BeulogueConfig.from_yaml(File.read(configPath))
      config.cwd = cwd
      config.targetDir = cwdPath.join("public").to_s

      config
    end
  end
end
