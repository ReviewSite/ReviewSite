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

ActiveRecord::Schema.define(:version => 20121028000012) do

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "project_worked_on"
    t.string   "role_description"
    t.text     "tech_exceeded"
    t.text     "tech_met"
    t.text     "tech_improve"
    t.text     "client_exceeded"
    t.text     "client_met"
    t.text     "client_improve"
    t.text     "ownership_exceeded"
    t.text     "ownership_met"
    t.text     "ownership_improve"
    t.text     "leadership_exceeded"
    t.text     "leadership_met"
    t.text     "leadership_improve"
    t.text     "teamwork_exceeded"
    t.text     "teamwork_met"
    t.text     "teamwork_improve"
    t.text     "attitude_exceeded"
    t.text     "attitude_met"
    t.text     "attitude_improve"
    t.text     "professionalism_exceeded"
    t.text     "professionalism_met"
    t.text     "professionalism_improve"
    t.text     "organizational_exceeded"
    t.text     "organizational_met"
    t.text     "organizational_improve"
    t.text     "innovative_exceeded"
    t.text     "innovative_met"
    t.text     "innovative_improve"
    t.text     "comments"
    t.integer  "review_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "submitted",                :default => false
    t.text     "user_string"
  end

  create_table "junior_consultants", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.text     "notes"
    t.integer  "reviewing_group_id"
  end

  create_table "reviewing_group_members", :force => true do |t|
    t.integer  "reviewing_group_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "reviewing_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviews", :force => true do |t|
    t.integer  "junior_consultant_id"
    t.string   "review_type"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.date     "review_date"
    t.date     "feedback_deadline"
    t.date     "send_link_date"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",           :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
