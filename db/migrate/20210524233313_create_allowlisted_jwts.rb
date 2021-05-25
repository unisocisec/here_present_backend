# frozen_string_literal: true

class CreateAllowlistedJwts < ActiveRecord::Migration[6.1]
  def change
    create_table :allowlisted_jwts do |t|
      t.string :jti, null: false, unique: true
      t.string :aud
      # If you want to leverage the `aud` claim, add to it a `NOT NULL` constraint:
      # t.string :aud, null: false
      t.datetime :exp, null: false
      t.references :teacher, foreign_key: { on_delete: :cascade }, null: false
      t.timestamps
    end
  end
end
