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

ActiveRecord::Schema.define(:version => 20120503000825) do

  create_table "courses", :force => true do |t|
    t.string   "abb"
    t.string   "name"
    t.string   "department"
    t.integer  "units"
    t.integer  "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "degrees", :force => true do |t|
    t.string   "name"
    t.integer  "units"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planners", :force => true do |t|
    t.integer  "user_id"
    t.integer  "semester_id"
    t.integer  "course_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "planner_name"
  end

  create_table "professors", :force => true do |t|
    t.string   "name"
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requireds", :force => true do |t|
    t.integer  "requirement_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirements", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "units"
  end

  create_table "satisfieds", :force => true do |t|
    t.integer  "degree_id"
    t.integer  "requirement_id"
    t.integer  "units"
    t.integer  "times"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "semesters", :force => true do |t|
    t.string   "semester"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taughts", :force => true do |t|
    t.integer  "professor_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "type"
    t.string   "username"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "started_at"
    t.string   "last_name"
    t.integer  "degree_id"
  end

end
