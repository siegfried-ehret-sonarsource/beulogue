require "crustache"

module Beulogue
  class Renderer
    getter fs : Crustache::ViewLoader
    getter list : Crustache::Template
    getter page : Crustache::Template

    def initialize
      fs = Crustache.loader Path[Dir.current].join("templates").to_s

      if fs
        @fs = fs
        @list = fs.load! "list.html"
        @page = fs.load! "page.html"
      else
        Beulogue.logger.fatal "Can't read templates"
        exit 1
      end
    end

    def renderList(model : Hash)
      html = Crustache.render(@list, model, @fs)
    end

    def renderPage(model : Hash)
      html = Crustache.render(@page, model, @fs)
    end
  end
end
