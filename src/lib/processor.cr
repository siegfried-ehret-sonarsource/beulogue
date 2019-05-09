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
        pages = files.map { |f| writePage(convert(f)) }
        writeList(pages)
      end
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

    private def convert(fromPath : Path)
      BeulogueObject.new(fromPath, @cwd)
    end

    private def writeList(pages : Array(BeuloguePage))
      model = {
        "pages"    => pages.sort_by { |p| p.date }.reverse.map { |p| p.to_hash },
        "language" => "en",
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
        File.write(Path[targetDir].join("index.html").to_s,
          HTML.unescape(Crustache.render(@templates.list, model)))
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
