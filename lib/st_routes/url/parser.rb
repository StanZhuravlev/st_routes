module StRoutes
  module URL
    class Parser
      # Очищенный путь, без хоста и GET-параметров
      attr_reader :url
      # Тип пути: :mainpage, :category, :page, :not_found
      attr_reader :type
      # Идентификатор категории в таблице StRoutes::Category. Равен "0" если категория не найдена
      attr_reader :category_id
      # Идентификатор страницы в таблице StRoutes::Page. Равен "0" если страница не найдена
      attr_reader :page_id
      # Идентифкаторы категорий для построения "хлебных крошек"
      attr_reader :breadcrumb
      # Наименование контроллера Rails для обработки пути данного типа
      attr_reader :controller
      # Наименование действия Rails для обработки пути данного типа
      attr_reader :action


      # Конструктор принимает на вход url страницы, парсит ее, и формирует
      # блок информации о ее типе, идентификаторах в СУБД, наименовании контроллера
      # (controller) и действия (action)
      #
      # @param [String] url адрес URL набраный клиентом. Может включать хост, путь, строку GET-параметров.
      #   Обязательным параметром является только путь
      def initialize(url)
        @url = url
        build_response(:not_found, 'errors', 'url_not_found', [], 0, 0)
        normalize_url
        parse
      end


      private


      def normalize_url #:nodoc:
        @url = @url.mb_chars.downcase.strip.to_s
        delete_host
        delete_params
        delete_end_slash
      end

      def delete_host #:nodoc:
        if @url.match(/\Ahttp/i)
          parts = @url.gsub('://', '').split('/')
          parts.shift
          @url = parts.join('/')
        end
      end

      def delete_params #:nodoc:
        @url = @url.split('?').first
      end

      def delete_end_slash #:nodoc:
        parts = @url.split('/')
        parts.delete_if { |x| x.strip.empty? }
        @url = "/#{parts.join('/')}".squeeze('/')
      end

      def parse #:nodoc:
        parts = @url.split('/')
        page_url = parts.pop || ""
        category_url = parts.join('/')
        category_url = "/" if category_url.empty?
        return true if mainpage?(category_url, page_url)
        return true if page?(category_url, page_url)
        return true if category?(@url)
        false
      end

      def mainpage?(category_url, page_url) #:nodoc:
        if category_url == '/' && page_url.empty?
          build_response(:mainpage, 'mainpage', 'mainpage', [], 0, 0)
          true
        else
          false
        end
      end

      def page?(category_url, page_url) #:nodoc:
        page = StRoutes::Page.where(slug: page_url).first
        category = StRoutes::CategoryUrl.where(full_url: category_url).first
        if !category.nil? && !page.nil?
          if StRoutes::PageLink.exists?(category_id: category.category_id, page_id: page.id)
            build_response(:page, page.controller, 'show', category.breadcrumb, category.category_id, page.id)
            return true
          end
        end
        false
      end

      def category?(url) #:nodoc:
        category = StRoutes::CategoryUrl.where(full_url: url).first
        if category.nil?
          false
        else
          build_response(:category, category.controller, 'index', category.breadcrumb, category.category_id, 0)
          true
        end
      end

      def build_response(type, controller, action, breadcrumb, category_id, page_id) #:nodoc:
        @type = type
        @controller = controller
        @action = action
        @breadcrumb = breadcrumb
        @category_id = category_id
        @page_id = page_id
      end

    end
  end
end