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

ActiveRecord::Schema.define(version: 2021_05_24_233313) do

  create_table "allowlisted_jwts", charset: "utf8", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.bigint "teacher_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["teacher_id"], name: "index_allowlisted_jwts_on_teacher_id"
  end

  create_table "call_lists", charset: "utf8", force: :cascade do |t|
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

  create_table "classrooms", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "school", null: false
    t.string "week_day", null: false
    t.integer "shift", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "student_answers", charset: "utf8", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "confirmation_code", null: false
    t.boolean "edited", default: false
    t.boolean "answer_correct", default: false
    t.bigint "call_list_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["call_list_id"], name: "index_student_answers_on_call_list_id"
  end

  create_table "teacher_classrooms", charset: "utf8", force: :cascade do |t|
    t.bigint "teacher_id"
    t.bigint "classroom_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["classroom_id"], name: "index_teacher_classrooms_on_classroom_id"
    t.index ["teacher_id"], name: "index_teacher_classrooms_on_teacher_id"
  end

  create_table "teachers", charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_teachers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_teachers_on_unlock_token", unique: true
  end

  add_foreign_key "allowlisted_jwts", "teachers", on_delete: :cascade
  add_foreign_key "teacher_classrooms", "classrooms"
  add_foreign_key "teacher_classrooms", "teachers"
end
