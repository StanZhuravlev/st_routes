module StRoutes
  class Canonical

    def self.url_for(category, page, host: "")
      out = "/"

      if page
        out = StRoutes::Canonical.category_root(page.controller)
        out += ('/' + page.slug)
      elsif category
        begin
          out = category.full_url
        rescue
          out = StRoutes::Canonical.category_root(category.controller)
        end
      end

      host.gsub(/\/\z/, '') + out.squeeze('/')
    end

    def self.category_root(controller)
      out = "/"
      item = StRoutes::Category.root(controller)
      if item
        out += (item.in_path ? item.slug : "")
      end
      out
    end

  end
end