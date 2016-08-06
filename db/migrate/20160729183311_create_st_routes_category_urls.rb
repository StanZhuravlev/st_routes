class CreateStRoutesCategoryUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_category_urls do |t|
      t.string      :controller,    default: '',      limit: 64
      t.integer     :category_id,   default: 0
      t.boolean     :is_canonical,  default: false
      t.string      :full_url,      default: '',      limit: 1024
      t.string      :short_url,     default: '',      limit: 1024
      t.text        :breadcrumb
      t.boolean     :is_new,        default: true

      t.timestamps
    end

    add_index :st_routes_category_urls, :controller
    add_index :st_routes_category_urls, :category_id
    add_index :st_routes_category_urls, :is_canonical
    add_index :st_routes_category_urls, :full_url
    # add_index :st_routes_category_urls, :short_url
    add_index :st_routes_category_urls, :updated_at
    add_index :st_routes_category_urls, :is_new
  end
end
