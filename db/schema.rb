# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_23_220646) do

  create_table "call_lists", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "date_start"
    t.datetime "date_end"
    t.datetime "expired_at"
    t.bigint "classroom_id"
    t.string "confirmation_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["classroom_id"], name: "index_call_lists_on_classroom_id"
  end

  create_table "classrooms", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "school", null: false
    t.string "week_day", null: false
    t.integer "shift", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_answers", charset: "utf8mb4", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "confirmation_code", null: false
    t.boolean "edited", default: false
    t.bigint "call_list_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["call_list_id"], name: "index_student_answers_on_call_list_id"
  end

  create_table "students", primary_key: "id_student", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "id_classes_lists", null: false
    t.string "name", null: false
    t.string "email", limit: 100, null: false
    t.date "date", null: false
  end

  create_table "teacher_classrooms", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "teacher_id"
    t.bigint "classroom_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["classroom_id"], name: "index_teacher_classrooms_on_classroom_id"
    t.index ["teacher_id"], name: "index_teacher_classrooms_on_teacher_id"
  end

  create_table "teachers", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  add_foreign_key "teacher_classrooms", "classrooms"
  add_foreign_key "teacher_classrooms", "teachers"
end
