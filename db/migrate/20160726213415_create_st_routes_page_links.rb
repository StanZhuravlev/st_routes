class CreateStRoutesPageLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_page_links do |t|
      t.integer     :page_id,       default: 0
      t.integer     :category_id,   default: 0

      t.timestamps
    end

    add_index :st_routes_page_links, :page_id
    add_index :st_routes_page_links, :category_id
  end
end
