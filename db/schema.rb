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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110715074647) do

  create_table "dependencies", :force => true do |t|
    t.integer  "version_id"
    t.integer  "dependency_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dependencies", ["dependency_id"], :name => "index_dependencies_on_dependency_id"
  add_index "dependencies", ["version_id"], :name => "index_dependencies_on_version_id"

  create_table "news", :force => true do |t|
    t.integer  "author_id"
    t.string   "uri"
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["author_id"], :name => "index_news_on_author_id"
  add_index "news", ["uri"], :name => "index_news_on_uri"

  create_table "packages", :force => true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "license"
    t.string   "home_url"
  end

  add_index "packages", ["created_at"], :name => "index_packages_on_created_at"
  add_index "packages", ["name"], :name => "index_packages_on_name"
  add_index "packages", ["owner_id"], :name => "index_packages_on_owner_id"
  add_index "packages", ["updated_at"], :name => "index_packages_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "role"
    t.string   "uid",           :null => false
    t.string   "provider",      :null => false
    t.string   "avatar_url"
    t.string   "home_url"
    t.string   "last_login_ip"
    t.datetime "last_login_at"
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token", :unique => true
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true

  create_table "versions", :force => true do |t|
    t.integer  "package_id"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "readme"
  end

  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["package_id"], :name => "index_versions_on_package_id"

end
