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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 2) do

  create_table "attachments", :force => true do |t|
    t.string   "label"
    t.integer  "document_id"
    t.string   "document_class"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "counter"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.boolean  "starred"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "attachments", ["attach_updated_at"], :name => "index_attachments_on_attach_updated_at"
  add_index "attachments", ["document_class"], :name => "index_attachments_on_document_class"
  add_index "attachments", ["document_id"], :name => "index_attachments_on_document_id"
  add_index "attachments", ["label"], :name => "index_attachments_on_label"

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.boolean  "keep_alive"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "histories", :force => true do |t|
    t.text     "value"
    t.string   "label"
    t.string   "document_class"
    t.integer  "document_id"
    t.integer  "created_by"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "histories", ["created_at"], :name => "index_histories_on_created_at"
  add_index "histories", ["document_class"], :name => "index_histories_on_document_class"
  add_index "histories", ["document_id"], :name => "index_histories_on_document_id"
  add_index "histories", ["label"], :name => "index_histories_on_label"

  create_table "notes", :force => true do |t|
    t.text     "note"
    t.string   "label"
    t.string   "document_class"
    t.integer  "document_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "starred"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "notes", ["document_class"], :name => "index_notes_on_document_class"
  add_index "notes", ["document_id"], :name => "index_notes_on_document_id"
  add_index "notes", ["label"], :name => "index_notes_on_label"
  add_index "notes", ["updated_at"], :name => "index_notes_on_updated_at"

  create_table "sections", :force => true do |t|
    t.string   "title"
    t.integer  "document_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "watchers", :force => true do |t|
    t.integer  "owner_id"
    t.string   "label"
    t.string   "document_class"
    t.integer  "document_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "watchers", ["created_at"], :name => "index_watchers_on_created_at"
  add_index "watchers", ["document_id"], :name => "index_watchers_on_document_id"
  add_index "watchers", ["label"], :name => "index_watchers_on_label"
  add_index "watchers", ["owner_id"], :name => "index_watchers_on_owner_id"

end
