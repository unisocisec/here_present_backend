# frozen_string_literal: true

class TeacherClassroom < ApplicationRecord
  belongs_to :teacher
  belongs_to :classroom

  validates :teacher_id, presence: true
  validates :classroom_id, presence: true

  def registration_date
    created_at
  end
end
