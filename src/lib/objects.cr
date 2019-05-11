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
      date: Time,
      description: String,
      title: String,
    )
  end

  class BeulogueObject
    getter fromPath : Path
    getter toPath : Path
    getter toURL : String
    getter content : String
    getter lang : String
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
      @lang = lang

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
    getter beulogueCwd : String?
    getter content : String
    getter date : Time
    getter description : String
    getter language : String
    getter title : String
    getter siteTitle : String
    getter siteLanguages : Array(String)
    getter url : String

    def initialize(bo : BeulogueObject, config : BeulogueConfig)
      @beulogueCwd = config.cwd
      @content = bo.content
      @date = bo.frontMatter.date
      @description = bo.frontMatter.description
      @language = bo.lang
      @siteTitle = config.title
      @siteLanguages = config.languages
      @title = bo.frontMatter.title
      @url = bo.toURL
    end

    def to_hash
      model = {
        "beulogue" => {
          "cwd" => @beulogueCwd,
        },
        "content"     => @content,
        "date"        => @date,
        "description" => @description,
        "language"    => @language,
        "site"        => {
          "title"     => @siteTitle,
          "languages" => @siteLanguages,
        },
        "title" => @title,
        "url"   => @url,
      }

      model
    end
  end
end
