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

ActiveRecord::Schema.define(:version => 20150713185148) do

  create_table "additional_emails", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  create_table "associate_consultants", :force => true do |t|
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.text     "notes"
    t.integer  "reviewing_group_id"
    t.integer  "coach_id"
    t.integer  "user_id"
    t.boolean  "graduated",          :default => false
    t.date     "program_start_date"
  end

  add_index "associate_consultants", ["coach_id"], :name => "index_associate_consultants_on_coach_id"
  add_index "associate_consultants", ["reviewing_group_id"], :name => "index_associate_consultants_on_reviewing_group_id"
  add_index "associate_consultants", ["user_id"], :name => "index_associate_consultants_on_user_id"

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
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.boolean  "submitted",                        :default => false
    t.text     "user_string"
    t.text     "role_competence_went_well"
    t.text     "role_competence_to_be_improved"
    t.text     "consulting_skills_went_well"
    t.text     "consulting_skills_to_be_improved"
    t.text     "teamwork_went_well"
    t.text     "teamwork_to_be_improved"
    t.text     "contributions_went_well"
    t.text     "contributions_to_be_improved"
    t.string   "reported_by"
  end

  add_index "feedbacks", ["user_id"], :name => "index_feedbacks_on_user_id"

  create_table "invitations", :force => true do |t|
    t.string   "email"
    t.integer  "review_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "invitations", ["review_id"], :name => "index_invitations_on_review_id"

  create_table "reviewing_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reviewing_groups_users", :id => false, :force => true do |t|
    t.integer "reviewing_group_id"
    t.integer "user_id"
  end

  add_index "reviewing_groups_users", ["user_id", "reviewing_group_id"], :name => "index_reviewing_groups_users_on_user_id_and_reviewing_group_id"
  add_index "reviewing_groups_users", ["user_id"], :name => "index_reviewing_groups_users_on_user_id"

  create_table "reviews", :force => true do |t|
    t.integer  "associate_consultant_id"
    t.string   "review_type"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.date     "review_date"
    t.date     "feedback_deadline"
    t.boolean  "new_review_format",       :default => false
  end

  add_index "reviews", ["associate_consultant_id"], :name => "index_reviews_on_associate_consultant_id"

  create_table "self_assessments", :force => true do |t|
    t.integer  "review_id"
    t.integer  "associate_consultant_id"
    t.text     "response"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.text     "learning_assessment"
  end

  add_index "self_assessments", ["associate_consultant_id"], :name => "index_self_assessments_on_associate_consultant_id"
  add_index "self_assessments", ["review_id"], :name => "index_self_assessments_on_review_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "admin",      :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "okta_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
