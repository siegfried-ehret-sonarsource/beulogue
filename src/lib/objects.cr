require "crustache"

module Beulogue
  class BeulogueConfig
    YAML.mapping(
      # From beulogue.yaml
      base: String,
      title: String,
      languages: Array(String),

      # Injected
      cwd: String?,
      targetDir: String?,
    )
  end

  class BeulogueFrontMatter
    YAML.mapping(
      title: String,
      date: Time,
    )
  end

  class BeulogueObject
    getter fromPath : Path
    getter toPath : Path
    getter toURL : String
    getter content : String
    getter frontMatter : BeulogueFrontMatter

    def initialize(@fromPath : Path, lang : String, cwd : Path)
      frontMatterDelimiter = "---"
      frontMatterDelimiterCount = 0
      frontMatter = ""
      content = ""

      File.read_lines(fromPath).each do |line|
        if frontMatterDelimiterCount < 2
          if line == frontMatterDelimiter
            frontMatterDelimiterCount += 1
          else
            frontMatter += line + "\n"
          end
        else
          content += line + "\n"
        end
      end

      @frontMatter = BeulogueFrontMatter.from_yaml(frontMatter)
      @content = Markdown.to_html(content)

      tempToPath = fromPath.to_s.sub("/content/", "/public/#{lang}/")

      if (tempToPath.ends_with?(".#{lang}.md"))
        @toPath = Path[tempToPath.sub(".#{lang}.md", ".html")]
      else
        @toPath = Path[tempToPath.sub(".md", ".html")]
      end

      @toURL = @toPath.to_s.gsub("//", "/").sub(cwd.join("public").to_s, "")
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

  class BeuloguePage
    getter title : String
    getter date : Time
    getter content : String
    getter language : String
    getter url : String
    getter siteTitle : String
    getter siteLanguages : Array(String)
    getter beulogueCwd : String?

    def initialize(bo : BeulogueObject, config : BeulogueConfig)
      @title = bo.frontMatter.title
      @date = bo.frontMatter.date
      @content = bo.content
      @language = config.languages[0]
      @url = bo.toURL
      @siteTitle = config.title
      @siteLanguages = config.languages
      @beulogueCwd = config.cwd
    end

    def to_hash
      model = {
        "title"    => @title,
        "date"     => @date,
        "content"  => @content,
        "language" => @language,
        "url"      => @url,
        "site"     => {
          "title"     => @siteTitle,
          "languages" => @siteLanguages,
        },
        "beulogue" => {
          "cwd" => @beulogueCwd,
        },
      }

      model
    end
  end
end
