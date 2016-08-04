module StRoutes
  class PageLink < ApplicationRecord
    belongs_to :page
    has_many :category_url, foreign_key: "category_id"


  end
end
