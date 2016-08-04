module StRoutes
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    # Метод конвертирует строку в транлитерированное имя файла
    #   @param [String] str имя файла в свободной форме
    #   @return [String] транслитерированное имя файла на латинице
    def string_to_slug(str)
      I18n.available_locales = [:"ru-RU", :ru]
      I18n.locale = :ru
      s = ActiveSupport::Inflector.transliterate(str, replacement = "x")
      s.parameterize
    end

    # Метод формирует URL из title страницы
    #   @return [String] транслитерированное имя файла на латинице, уникальное
    def generate_slug
      if slug.empty? && title.present?
        probably_slug = string_to_slug(title)
        case
          when self.class.name.match(/Category\z/)
            slugs = StRoutes::Category.select(:slug).where("slug LIKE ?" , "#{probably_slug}%").order(slug: :asc).pluck(:slug)
          when self.class.name.match(/Page\z/)
            slugs = StRoutes::Page.select(:slug).where("slug LIKE ?" , "#{probably_slug}%").order(slug: :asc).pluck(:slug)
          else
            raise "Функция generate_slug может вызываться только для классов StRoutes::Page или StRoutes::Category"
        end
        tmp_slug = probably_slug
        1.upto(1000) do |idx|
          if slugs.include?(tmp_slug)
            tmp_slug =  probably_slug + '-' + idx.to_s
          else
            self.slug = tmp_slug
            break
          end
        end
      end
    end

  end
end
