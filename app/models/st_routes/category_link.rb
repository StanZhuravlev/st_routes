module StRoutes
  class CategoryLink < ApplicationRecord
    belongs_to :parent_category, class_name: 'Category'
    belongs_to :category

  end
end
