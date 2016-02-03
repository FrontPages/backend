# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160203162924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collection_snapshots", force: :cascade do |t|
    t.integer  "collection_id"
    t.integer  "snapshot_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "collection_snapshots", ["collection_id"], name: "index_collection_snapshots_on_collection_id", using: :btree
  add_index "collection_snapshots", ["snapshot_id"], name: "index_collection_snapshots_on_snapshot_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "permalink"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "headlines", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "url",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "snapshot_id"
    t.integer  "story_id"
  end

  add_index "headlines", ["created_at"], name: "index_headlines_on_created_at", using: :btree
  add_index "headlines", ["snapshot_id"], name: "index_headlines_on_snapshot_id", using: :btree
  add_index "headlines", ["story_id"], name: "index_headlines_on_story_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.string   "selector",   limit: 255
    t.string   "shortcode",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "script"
  end

  create_table "snapshots", force: :cascade do |t|
    t.string   "filename",             limit: 255
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail"
    t.boolean  "keyframe",                         default: true
    t.text     "searchable_headlines"
  end

  add_index "snapshots", ["created_at"], name: "index_snapshots_on_created_at", order: {"created_at"=>:desc}, where: "(keyframe = true)", using: :btree
  add_index "snapshots", ["site_id"], name: "index_snapshots_on_site_id", using: :btree

  create_table "stories", force: :cascade do |t|
    t.string   "url"
    t.integer  "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stories", ["site_id"], name: "index_stories_on_site_id", using: :btree

  add_foreign_key "collection_snapshots", "collections"
  add_foreign_key "collection_snapshots", "snapshots"
  add_foreign_key "stories", "sites"
end
