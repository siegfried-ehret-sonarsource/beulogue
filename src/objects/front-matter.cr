module Beulogue
  class BeulogueFrontMatter
    YAML.mapping(
      date: Time,
      description: String,
      title: String,
    )
  end
end
