module StRoutes
  class Sitemap

    def self.urls(host = "")
      arr = StRoutes::Sitemap.sitemap
      Array.new.tap do |out|
        arr.each do |url|
          out << host.gsub(/\/{1,100}\z/, '') + url
        end
      end
    end

    def self.sitemap
      # Шаг 1 - Читаем страницы и id категорий
      pages = Array.new
      category_ids = Array.new
      StRoutes::Page.includes(:page_links).where(is_published: true).find_each do |page|
        item = Hash.new
        item[:page_id] = page.id
        item[:category_ids] = page.page_links.pluck(:category_id)
        item[:slug] = page.slug
        pages << item
        category_ids += item[:category_ids]
      end

      # Шаг 2 - загружаем категории
      categories = Hash.new
      StRoutes::CategoryUrl.where(category_id: category_ids.uniq).find_each do |r|
        categories[r.category_id] ||= Array.new
        categories[r.category_id] << r.full_url
      end

      # Шаг 3 - Строим массив адресов страниц на сайте
      out = Array.new
      pages.each do |page|
        page[:category_ids].each do |p_id|
          categories.each do |c_id, urls|
            if p_id == c_id
              urls.each do |url|
                out << "#{url}/#{page[:slug]}".squeeze('/')
              end
            end
          end
        end
      end

      out.sort
    end

  end
end