# frozen_string_literal: true

class Classroom < ApplicationRecord
  include GenerateCsv

  has_many :teacher_classrooms, dependent: :destroy
  has_many :teachers, through: :teacher_classrooms
  has_many :call_lists, dependent: :destroy
  has_many :student_answers, through: :call_lists

  serialize :weekdays, Array

  OPTIONS_SHIFT = %w[Diurnal Vespertine Nightly].freeze
  OPTIONS_WEEKDAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze
  validates :name, presence: true
  validates :shift, inclusion: { in: OPTIONS_SHIFT, message: '%<value>s is not a valid shift' }, allow_blank: true

  validate :check_weekdays

  def check_weekdays
    weekdays.each do |week|
      errors.add(:weekdays, 'Datas de Semana Invalidas') unless OPTIONS_WEEKDAYS.include?(week)
    end
  end

  def self.column_names_to_export
    attribute_names.map { |column| human_attribute_name(column) }
  end

  def export_attributes
    attributes
  end

  def translation_columns
    shift_translate
    weekdays_translate
  end

  def shift_translate
    self.shift = Classroom.human_enum_name(:shift, shift)
  end

  def weekdays_translate
    self.weekdays = weekdays.map { |weekday| Classroom.human_enum_name(:weekday, weekday) }
  end
end
