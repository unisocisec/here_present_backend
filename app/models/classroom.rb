# frozen_string_literal: true

class Classroom < ApplicationRecord
  DIURNAL = 0
  VESPERTINE = 1
  NIGHTLY = 2

  enum shift: %i[DIURNAL VESPERTINE NIGHTLY]
  enum week_day: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
  validates :name, presence: true
  validates :shift, inclusion: { in: Classroom.shifts.keys }, presence: true
  validates :week_day, inclusion: { in: Classroom.week_days.keys }, presence: true
end
