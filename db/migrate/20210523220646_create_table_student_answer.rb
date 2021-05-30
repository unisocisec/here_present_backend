# frozen_string_literal: true

class CreateTableStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    create_table :student_answers do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :confirmation_code, null: false
      t.boolean :edited, default: false
      t.boolean :answer_correct, default: false

      t.references :call_list
      t.timestamps
    end
  end
end
