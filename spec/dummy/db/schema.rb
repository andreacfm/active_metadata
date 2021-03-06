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

ActiveRecord::Schema.define(:version => 1) do

  create_table "active_metadata_attachments", :force => true do |t|
    t.string   "label"
    t.integer  "model_id"
    t.string   "model_class"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "counter"
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
    t.boolean  "starred"
    t.string   "group"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "active_metadata_attachments", ["attach_updated_at"], :name => "index_active_metadata_attachments_on_attach_updated_at"
  add_index "active_metadata_attachments", ["label"], :name => "index_active_metadata_attachments_on_label"
  add_index "active_metadata_attachments", ["model_class"], :name => "index_active_metadata_attachments_on_model_class"
  add_index "active_metadata_attachments", ["model_id"], :name => "index_active_metadata_attachments_on_model_id"

  create_table "active_metadata_histories", :force => true do |t|
    t.text     "value"
    t.string   "label"
    t.string   "model_class"
    t.integer  "model_id"
    t.integer  "created_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "active_metadata_histories", ["created_at"], :name => "index_active_metadata_histories_on_created_at"
  add_index "active_metadata_histories", ["label"], :name => "index_active_metadata_histories_on_label"
  add_index "active_metadata_histories", ["model_class"], :name => "index_active_metadata_histories_on_model_class"
  add_index "active_metadata_histories", ["model_id"], :name => "index_active_metadata_histories_on_model_id"

  create_table "active_metadata_notes", :force => true do |t|
    t.text     "note"
    t.string   "label"
    t.string   "model_class"
    t.integer  "model_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.boolean  "starred"
    t.string   "group"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "active_metadata_notes", ["label"], :name => "index_active_metadata_notes_on_label"
  add_index "active_metadata_notes", ["model_class"], :name => "index_active_metadata_notes_on_model_class"
  add_index "active_metadata_notes", ["model_id"], :name => "index_active_metadata_notes_on_model_id"
  add_index "active_metadata_notes", ["updated_at"], :name => "index_active_metadata_notes_on_updated_at"

  create_table "active_metadata_watchers", :force => true do |t|
    t.integer  "owner_id"
    t.string   "label"
    t.string   "model_class"
    t.integer  "model_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "active_metadata_watchers", ["created_at"], :name => "index_active_metadata_watchers_on_created_at"
  add_index "active_metadata_watchers", ["label"], :name => "index_active_metadata_watchers_on_label"
  add_index "active_metadata_watchers", ["model_id"], :name => "index_active_metadata_watchers_on_model_id"
  add_index "active_metadata_watchers", ["owner_id"], :name => "index_active_metadata_watchers_on_owner_id"

end
