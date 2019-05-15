module Beulogue
  class BeulogueFrontMatter
    YAML.mapping(
      date: Time,
      description: String,
      title: String,
      tags: Array(String)?
    )
  end
end
