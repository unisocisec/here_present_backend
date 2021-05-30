# frozen_string_literal: true

class CallList < ApplicationRecord
  belongs_to :classroom
  has_many :student_answers
  has_many :teacher_classrooms, through: :classroom
  has_many :teachers, through: :teacher_classrooms

  validates :title, :classroom_id, presence: true
  validate :check_overlapping

  private

  def check_overlapping
    if date_end.blank? || date_start.blank?
      true
    elsif date_start > date_end
      errors.add(
        :date_end,
        "A data de término deve ser posterior à data de início -> Dados: Data de Início: #{date_start} e Data de Final: #{date_end}"
      )
    end
  end
end
