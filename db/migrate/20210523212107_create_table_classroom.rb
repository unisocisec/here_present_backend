# frozen_string_literal: true

class CreateTableClassroom < ActiveRecord::Migration[6.1]
  def change
    create_table :classrooms do |t|
      t.string :name, null: false
      t.string :school
      t.string :weekdays
      t.string :shift
      t.timestamps
    end
  end
end
