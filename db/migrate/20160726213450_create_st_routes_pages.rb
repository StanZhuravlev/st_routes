class CreateStRoutesPages < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_pages do |t|
      t.string      :title,        default: '',      limit: 1024
      t.string      :slug,         default: '',      limit: 1024
      t.string      :controller,   default: '',      limit: 64
      t.boolean     :is_published, default: true

      t.timestamps
    end

    add_index :st_routes_pages, :slug
    add_index :st_routes_pages, :controller
    add_index :st_routes_pages, :is_published
  end
end
