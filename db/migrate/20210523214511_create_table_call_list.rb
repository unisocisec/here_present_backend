# frozen_string_literal: true

class CreateTableCallList < ActiveRecord::Migration[6.1]
  def change
    create_table :call_lists do |t|
      t.string :title, null: false
      t.datetime :date_start
      t.datetime :date_end
      t.datetime :expired_at
      t.references :classroom
      t.string :confirmation_code, null: false
      t.timestamps
    end
  end
end
