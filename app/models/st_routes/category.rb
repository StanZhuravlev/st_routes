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

    has_many :category_urls, foreign_key: 'category_id'

    has_many :category_links
    has_many :parent_categories, through: :category_links, dependent: :destroy
    has_many :categories, through: :category_links, dependent: :destroy

    after_save :rebuild_categories_urls

    def generate_slug
      self.slug = StRoutes::URL::Slug.generate_slug(StRoutes::Category, self.title, self.slug)
    end

    def rebuild_categories_urls
      if slug_changed? || in_path_changed? || is_root_changed?
        builder = StRoutes::URL::Builder.new
        builder.rebuild_categories_urls
      end
    end

    def add_subcategory(subitem)
      StRoutes::CategoryLink.where(category_id: subitem.id, parent_category_id: id).first_or_create
      builder = StRoutes::URL::Builder.new
      builder.rebuild_categories_urls
    end

    def self.root(controller)
      StRoutes::Category.where(controller: controller.to_s, is_root: true).first
    end

    def self.roots
      StRoutes::Category.where(is_root: true)
    end

    def update_pages_count
      self.pages_count = StRoutes::PageLink.where(category_id: id).count
      ids = StRoutes::CategoryLink.select(:category_id).where(parent_category_id: id).pluck(:category_id)
      StRoutes::Category.where(id: ids).find_each do |one|
        one.update_pages_count
        self.pages_count += one.pages_count
      end
      save
    end

  end
end
