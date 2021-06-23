# frozen_string_literal: true

class CallList < ApplicationRecord
  include GenerateCsv

  belongs_to :classroom
  has_many :student_answers, dependent: :delete_all
  has_many :teacher_classrooms, through: :classroom
  has_many :teachers, through: :teacher_classrooms

  validates :title, :classroom_id, presence: true
  validate :check_overlapping

  def self.column_names_to_export
    attribute_names.map { |column| human_attribute_name(column) }
  end

  def export_attributes
    attributes
  end

  def token_encode
    JWT.encode({ call_list_id: id }, ENV['CALL_LIST_SECRET'], 'HS256')
  end

  private

  def check_overlapping
    if date_end.blank? || date_start.blank?
      true
    elsif date_start > date_end
      errors.add(:date_end, I18n.t('check_overlapping_call_list', date_start: date_start, date_end: date_end))
    end
  end
end
