module StRoutes
  class Page < ApplicationRecord
    validates :title, presence: true
    validates :slug, presence: true
    validates :controller, presence: true
    validates :title, length: { maximum: 1024 }
    validates :slug, length: { maximum: 1024 }
    validates :controller, length: { maximum: 64 }
    validates :slug, uniqueness: true

    has_many :page_links
    has_many :category_urls, through: :page_links

    after_save :connect_to_canonical

    def generate_slug
      self.slug = StRoutes::URL::Slug.generate_slug(StRoutes::Page, self.title, self.slug)
    end

    def connect_to_canonical
      item = StRoutes::Category.root(controller)
      connect_to_category(item)
    end

    def connect_to_category(record)
      unless record.nil?
        r = StRoutes::PageLink.where(category_id: record.id, page_id: id).first_or_create
      end
    end


  end
end
