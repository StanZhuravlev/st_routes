class CreateStRoutesCategoryLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_category_links do |t|
      t.integer     :parent_id,       default: 0
      t.integer     :child_id,        default: 0

      t.timestamps
    end

    add_index :st_routes_category_links, :parent_id
    add_index :st_routes_category_links, :child_id
  end
end
