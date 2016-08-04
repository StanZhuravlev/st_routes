module StRoutes
  module URL
    class Builder

      # Метод обеспечивает:
      #  - перестроение дерева путей категорий в таблице `category_urls`
      #  - удаление старых, неиспользованных путей
      #  - формирование массива ID категорий для "хлебных крошек"
      #
      # @return [None] нет
      def rebuild_categories_urls
        roots = StRoutes::Category.where(is_root: true)
        StRoutes::CategoryUrl.transaction do
          roots.each do |root|
            canonical = create_category_full_url(root, "/", [])
            rebuild_subcategories_urls(canonical)
          end
        end
        delete_old_records
      end


      private


      def rebuild_subcategories_urls(record) #:nodoc:
        ids = StRoutes::CategoryLink.where(parent_id: record.category_id).pluck(:child_id)
        items = StRoutes::Category.where(id: ids)
        items.each do |one|
          res = create_category_full_url(one, record.full_url, record.breadcrumb)
          rebuild_subcategories_urls(res)
        end
      end

      def create_category_full_url(category, full_url, breadcrumb) #:nodoc:
        if category.in_path
          full_url = [full_url, category.slug].join('/').squeeze('/')
          breadcrumb << category.id
        end

        StRoutes::CategoryUrl.where(full_url: full_url).first_or_initialize.tap do |item|
          item.category_id = category.id
          item.full_url = full_url
          item.breadcrumb = breadcrumb
          item.is_canonical = category.is_root
          item.controller = category.controller
          item.is_new = true
          item.save
        end
      end

      def delete_old_records #:nodoc:
        StRoutes::CategoryUrl.where(is_new: false).delete_all
        StRoutes::CategoryUrl.update_all(is_new: false)
      end

    end
  end
end

