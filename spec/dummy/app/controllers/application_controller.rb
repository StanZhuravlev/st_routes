class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :load_categories
  before_action :load_pages

  def load_categories
    @categories = StRoutes::CategoryUrl.includes(:category).all
  end

  def load_pages
    @pages = Array.new
    links = StRoutes::Page.sitemap
    links.each do |url|
      route = StRoutes::URL::Parser.new(url)
      if route.type == :page
        @pages << [url, StRoutes::Page.where(id: route.page_id).first ]
      end
    end
  end

end
