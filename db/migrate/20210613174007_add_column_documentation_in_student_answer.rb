class AddColumnDocumentationInStudentAnswer < ActiveRecord::Migration[6.1]
  def change
    add_column :student_answers, :documentaion, :string
  end
end
