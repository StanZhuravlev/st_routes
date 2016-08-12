class CreateStRoutesCategoryLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_category_links do |t|
      t.references :category, index: true, foreign_key: true
      t.references :parent_category, index: true, foreign_key: true

      t.timestamps
    end


    add_foreign_key :st_routes_category_links, :categories, column: :category_id
    add_foreign_key :st_routes_category_links, :parent_categories, column: :parent_category_id
    add_index :st_routes_category_links, [:category_id, :parent_category_id], name: "category_child_parent_idx", unique: true
  end
end
