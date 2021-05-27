# frozen_string_literal: true

class CreateTableTeacherClassroom < ActiveRecord::Migration[6.1]
  def change
    create_table :teacher_classrooms do |t|
      t.references :teacher, foreign_key: true
      t.references :classroom, foreign_key: true
      t.timestamps
    end
  end
end
