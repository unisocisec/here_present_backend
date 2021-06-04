# frozen_string_literal: true

class TeacherClassroom < ApplicationRecord
  belongs_to :teacher, dependent: :destroy
  belongs_to :classroom, dependent: :destroy

  validates :teacher_id, :classroom_id, presence: true

  def registration_date
    created_at
  end
end
