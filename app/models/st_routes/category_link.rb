module StRoutes
  class CategoryLink < ApplicationRecord
    belongs_to :parent_category, class_name: 'Category'
    belongs_to :category

    after_save :rebuild_categories_urls
    after_destroy :rebuild_categories_urls

    def rebuild_categories_urls
      builder = StRoutes::URL::Builder.new
      builder.rebuild_categories_urls
    end

  end
end
