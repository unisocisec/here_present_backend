# frozen_string_literal: true

class StudentAnswer < ApplicationRecord
  belongs_to :call_list
  has_one :classroom, through: :call_list
  has_many :teacher_classrooms, through: :classroom
  has_many :teachers, through: :teacher_classrooms

  validates :full_name, :email, :call_list_id, presence: true

  after_update :set_edited, if: :was_not_edited?
  after_save :set_answer_correct

  def was_not_edited?
    !edited
  end

  def set_edited
    update_column('edited', true)
  end

  def set_answer_correct
    update_column('answer_correct', call_list&.confirmation_code == confirmation_code)
  end
end
