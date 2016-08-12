module StRoutes
  module URL
    class Slug


      # Метод конвертирует строку в транлитерированное имя файла
      #   @param [String] str имя файла в свободной форме
      #   @return [String] транслитерированное имя файла на латинице
      def self.string_to_slug(str)
        I18n.available_locales = [:"ru-RU", :ru]
        I18n.locale = :ru
        s = ActiveSupport::Inflector.transliterate(str, replacement = "x")
        s.parameterize
      end

      # Метод формирует URL из title страницы
      #   @return [String] транслитерированное имя файла на латинице, уникальное
      def self.generate_slug(clazz, title, slug)
        return slug if slug.present?
        probably_slug = string_to_slug(title)
        slugs = clazz.select(:slug).where("slug LIKE ?" , "#{probably_slug}%").order(slug: :asc).pluck(:slug)
        tmp_slug = probably_slug
        1.upto(1000) do |idx|
          if slugs.include?(tmp_slug)
            tmp_slug =  probably_slug + '-' + idx.to_s
          else
            return tmp_slug
          end
        end
        "Slug is error"
      end


    end
  end
end
