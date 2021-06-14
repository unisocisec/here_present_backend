# frozen_string_literal: true

class AddColumnDocumentationInStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :student_answers, :documentation, :string
  end
end
