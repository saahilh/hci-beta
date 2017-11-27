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

ActiveRecord::Schema.define(version: 20171127000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lecturer_id"
    t.index ["lecturer_id"], name: "index_courses_on_lecturer_id"
  end

  create_table "lecturers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  create_table "options", force: :cascade do |t|
    t.integer "number"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "poll_id"
    t.integer "selected"
    t.index ["poll_id"], name: "index_options_on_poll_id"
  end

  create_table "polls", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_id"
    t.boolean "active"
    t.index ["course_id"], name: "index_polls_on_course_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.integer "upvotes", default: 0
    t.integer "downvotes", default: 0
    t.string "course"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending"
    t.bigint "course_id"
    t.integer "flagged", default: 0
    t.bigint "student_id"
    t.index ["course_id"], name: "index_questions_on_course_id"
    t.index ["student_id"], name: "index_questions_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "question_data", default: ""
    t.text "flagged", default: ""
    t.text "poll_data", default: ""
  end

end
