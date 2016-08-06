# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160729183311) do

  create_table "st_routes_categories", force: :cascade do |t|
    t.string   "controller",  limit: 64,   default: ""
    t.boolean  "is_root",                  default: false
    t.boolean  "in_path",                  default: false
    t.string   "title",       limit: 1024, default: ""
    t.string   "slug",        limit: 1024, default: ""
    t.string   "short_slug",  limit: 1024, default: ""
    t.integer  "pages_count",              default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["controller"], name: "index_st_routes_categories_on_controller"
    t.index ["in_path"], name: "index_st_routes_categories_on_in_path"
    t.index ["is_root"], name: "index_st_routes_categories_on_is_root"
    t.index ["pages_count"], name: "index_st_routes_categories_on_pages_count"
    t.index ["short_slug"], name: "index_st_routes_categories_on_short_slug"
    t.index ["slug"], name: "index_st_routes_categories_on_slug"
  end

  create_table "st_routes_category_links", force: :cascade do |t|
    t.integer  "parent_id",  default: 0
    t.integer  "child_id",   default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["child_id"], name: "index_st_routes_category_links_on_child_id"
    t.index ["parent_id"], name: "index_st_routes_category_links_on_parent_id"
  end

  create_table "st_routes_category_urls", force: :cascade do |t|
    t.string   "controller",   limit: 64,   default: ""
    t.integer  "category_id",               default: 0
    t.boolean  "is_canonical",              default: false
    t.string   "full_url",     limit: 1024, default: ""
    t.string   "short_url",    limit: 1024, default: ""
    t.text     "breadcrumb"
    t.boolean  "is_new",                    default: true
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["category_id"], name: "index_st_routes_category_urls_on_category_id"
    t.index ["controller"], name: "index_st_routes_category_urls_on_controller"
    t.index ["full_url"], name: "index_st_routes_category_urls_on_full_url"
    t.index ["is_canonical"], name: "index_st_routes_category_urls_on_is_canonical"
    t.index ["is_new"], name: "index_st_routes_category_urls_on_is_new"
    t.index ["updated_at"], name: "index_st_routes_category_urls_on_updated_at"
  end

  create_table "st_routes_page_links", force: :cascade do |t|
    t.integer  "page_id",     default: 0
    t.integer  "category_id", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["category_id"], name: "index_st_routes_page_links_on_category_id"
    t.index ["page_id"], name: "index_st_routes_page_links_on_page_id"
  end

  create_table "st_routes_pages", force: :cascade do |t|
    t.string   "title",        limit: 1024, default: ""
    t.string   "slug",         limit: 1024, default: ""
    t.string   "short_slug",   limit: 1024, default: ""
    t.string   "controller",   limit: 64,   default: ""
    t.boolean  "is_published",              default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["controller"], name: "index_st_routes_pages_on_controller"
    t.index ["is_published"], name: "index_st_routes_pages_on_is_published"
    t.index ["short_slug"], name: "index_st_routes_pages_on_short_slug"
    t.index ["slug"], name: "index_st_routes_pages_on_slug"
  end

end
