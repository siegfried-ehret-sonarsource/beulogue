module Beulogue
  class BeulogueConfig
    YAML.mapping(
      # From beulogue.yaml
      base: String,
      title: String,
      languages: Array(String),
      rssFilename: String?,

      # Injected
      cwd: String?,
      targetDir: String?,
    )
  end
end
