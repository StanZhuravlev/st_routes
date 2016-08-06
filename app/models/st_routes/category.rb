module StRoutes
  class Category < ApplicationRecord
    validates :title, presence: true
    validates :slug, presence: true
    validates :controller, presence: true
    validates :title, length: {maximum: 1024}
    validates :slug, length: {maximum: 1024}
    validates :controller, length: {maximum: 64}
    validates :slug, uniqueness: true
    validates :controller, uniqueness: true, if: Proc.new { |c| c.is_root }, on: :create
    validates :in_path, inclusion: {in: [true]}, if: Proc.new { |c| !c.is_root }

    before_validation :generate_slug
    before_save :generate_slug
    after_save :generate_short_slug
    after_save :rebuild_categories_urls

    def generate_slug
      StRoutes::URL::Slug.generate_slug(self)
    end

    def generate_short_slug
      StRoutes::URL::Slug.generate_short_slug(self)
    end

    def rebuild_categories_urls
      builder = StRoutes::URL::Builder.new
      builder.rebuild_categories_urls
    end

    def add_subcategory(subitem)
      StRoutes::CategoryLink.where(parent_id: id, child_id: subitem.id).first_or_create
    end

    def self.root(controller)
      StRoutes::Category.where(controller: controller.to_s, is_root: true).first
    end

    def self.roots
      StRoutes::Category.where(is_root: true)
    end

    def update_pages_count
      self.pages_count = StRoutes::PageLink.where(category_id: id).count
      ids = StRoutes::CategoryLink.select(:child_id).where(parent_id: id).pluck(:child_id)
      StRoutes::Category.where(id: ids).find_each do |one|
        one.update_pages_count
        self.pages_count += one.pages_count
      end
      save
    end

  end
end
