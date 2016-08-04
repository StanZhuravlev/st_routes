module StRoutes
  class CategoryUrl < ApplicationRecord
    serialize :breadcrumb

    has_one :category, foreign_key: 'id'

    def self.route_by_url(path)
      url = ('/' + path.mb_chars.downcase.to_s).squeeze('/')
      StRoutes::CategoryUrl.includes(:category).where(full_url: url).first
    end

    def self.route_to_url(route)
    end


  end
end
