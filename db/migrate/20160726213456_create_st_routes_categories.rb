class CreateStRoutesCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :st_routes_categories do |t|
      t.string      :controller,    default: '',      limit: 64
      t.boolean     :is_root,       default: false
      t.boolean     :in_path,       default: false
      t.string      :title,         default: '',      limit: 250
      t.string      :slug,          default: '',      limit: 250
      t.integer     :pages_count,   default: 0

      t.timestamps
    end

    add_index :st_routes_categories, :controller
    add_index :st_routes_categories, :is_root
    add_index :st_routes_categories, :in_path
    add_index :st_routes_categories, :slug
    add_index :st_routes_categories, :pages_count
  end
end
