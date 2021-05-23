# frozen_string_literal: true

class CreateTableClassroom < ActiveRecord::Migration[6.1]
  def change
    create_table :classrooms do |t|
      t.string :name, null: false
      t.string :school, null: false
      t.string :week_day, null: false
      t.integer :shift, null: false
      t.timestamps
    end
  end
end
