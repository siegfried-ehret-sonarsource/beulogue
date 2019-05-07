require "crustache"

module Beulogue
  class BeulogueConfig
    YAML.mapping(
      # From beulogue.yaml
      title: String,
      languages: Array(String),

      # Injected
      cwd: String?,
      targetDir: String?,
    )
  end

  class BeulogueObject
    getter fromPath : Path
    getter toPath : Path
    getter content : String

    def initialize(@fromPath : Path)
      @content = Markdown.to_html(File.read(fromPath))
      @toPath = Path[fromPath.to_s.sub("/content/", "/public/").sub(".md", ".html")]
    end
  end

  class BeulogueTemplates
    getter list : Crustache::Syntax::Template
    getter page : Crustache::Syntax::Template

    def initialize(path : Path)
      listPath = path.join("templates", "list.html")
      pagePath = path.join("templates", "page.html")
      @list = Crustache.parse File.read(listPath)
      @page = Crustache.parse File.read(pagePath)
    end
  end
end
