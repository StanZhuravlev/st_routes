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
      def self.generate_slug(record)
        if record.slug.empty? && record.title.present?
          probably_slug = string_to_slug(record.title)
          case
            when record.class.name.match(/Category\z/)
              slugs = StRoutes::Category.select(:slug).where("slug LIKE ?" , "#{probably_slug}%").order(slug: :asc).pluck(:slug)
            when record.class.name.match(/Page\z/)
              slugs = StRoutes::Page.select(:slug).where("slug LIKE ?" , "#{probably_slug}%").order(slug: :asc).pluck(:slug)
            else
              raise "Функция generate_slug может вызываться только для классов StRoutes::Page или StRoutes::Category"
          end
          tmp_slug = probably_slug
          1.upto(1000) do |idx|
            if slugs.include?(tmp_slug)
              tmp_slug =  probably_slug + '-' + idx.to_s
            else
              record.slug = tmp_slug
              break
            end
          end
        end
      end

      def self.generate_short_slug(record)
        return if record.short_slug.present?

        case
          when record.class.name.match(/Category\z/)
            prefix = 'c' + record.id.to_s.split.last
          when record.class.name.match(/Page\z/)
            prefix = 'p' + record.id.to_s.split.last
          else
            raise "Функция generate_slug может вызываться только для классов StRoutes::Page или StRoutes::Category"
        end

        record.short_slug = prefix + record.id.to_s(36)
        record.save
      end


    end
  end
end
