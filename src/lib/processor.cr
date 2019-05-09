require "html"
require "markdown"
require "./objects"

module Beulogue
  class Processor
    def initialize(cwd : String, @config : BeulogueConfig)
      @cwd = Path[cwd]
      @templates = BeulogueTemplates.new(@cwd)
    end

    def run
      if @config.targetDir.nil?
        puts "Can't find target directory"
        Process.exit
      else
        files = walk(@cwd)

        if @config.languages.size > 1
          pagesPerLanguage = splitPerLanguage(files, @config.languages)

          pagesPerLanguage.each do |lang, filesForLanguage|
            pages = filesForLanguage.map { |f| writePage(convert(f, lang)) }
            writeList(pages, lang)
          end

          writeRedirection(@config.languages[0])
        else
          lang = @config.languages[0]
          pages = files.map { |f| writePage(convert(f, "")) }
          writeList(pages, "")
        end
      end
    end

    private def splitPerLanguage(files : Array(Path), languages : Array(String))
      files.group_by { |f| languages.find { |e| f.to_s.ends_with?(".#{e}.md") } || languages[0] }
    end

    private def walk(path : Path, extra : String = "content")
      contentPath = path.join(extra)
      d = Dir.new(contentPath.to_s)

      files = [] of Path

      d.each_child do |x|
        currentPath = contentPath.join(x)
        if File.directory?(currentPath.to_s)
          files.concat(self.walk(currentPath, ""))
        else
          files.push(currentPath)
        end
      end

      files
    end

    private def convert(fromPath : Path, lang : String)
      BeulogueObject.new(fromPath, lang, @cwd)
    end

    private def writeList(pages : Array(BeuloguePage), lang : String)
      model = {
        "pages"    => pages.sort_by { |p| p.date }.reverse.map { |p| p.to_hash },
        "language" => lang,
        "site"     => {
          "title"     => @config.title,
          "languages" => @config.languages,
        },
        "beulogue" => {
          "cwd" => @config.cwd,
        },
      }

      targetDir = @config.targetDir

      if !targetDir.nil?
        File.write(Path[targetDir].join(lang, "index.html").to_s,
          HTML.unescape(Crustache.render(@templates.list, model)))
      end
    end

    private def writeRedirection(lang : String)
      targetDir = @config.targetDir

      if !targetDir.nil?
        html = "<!DOCTYPE html><html><head><title>{{base}}/{{lang}}</title><link rel=\"canonical\" href=\"{{base}}/{{lang}}\"/><meta name=\"robots\" content=\"noindex\"/><meta charset=\"utf-8\"/><meta http-equiv=\"refresh\" content=\"0; url={{base}}/{{lang}}\" /></head></html>"
        File.write(Path[targetDir].join("index.html").to_s,
          html.gsub("{{base}}", @config.base).gsub("{{lang}}", lang))
      end
    end

    private def writePage(bo : BeulogueObject)
      toDir = File.dirname(bo.toPath.to_s)
      Dir.mkdir_p(toDir)

      model = BeuloguePage.new(bo, @config)

      File.write(bo.toPath, HTML.unescape(Crustache.render(@templates.page, model.to_hash)))

      model
    end
  end
end
