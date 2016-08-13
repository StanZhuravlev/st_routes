class CreateStRoutesCategoryLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_category_links do |t|
      t.integer  :category_id,  default: 0
      t.integer  :parent_category_id,  default: 0

      t.timestamps
    end

    add_foreign_key :st_routes_category_links, :st_routes_categories, column: :category_id
    add_foreign_key :st_routes_category_links, :st_routes_categories, column: :parent_category_id
    add_index :st_routes_category_links, [:category_id, :parent_category_id], name: "category_child_parent_idx", unique: true
  end
end
