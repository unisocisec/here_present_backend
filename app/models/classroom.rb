# frozen_string_literal: true

class Classroom < ApplicationRecord
  DIURNAL = 0
  VESPERTINE = 1
  NIGHTLY = 2

  enum shift: %i[DIURNAL VESPERTINE NIGHTLY]
  OPTIONS_WEEK_DAY = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
  validates :name, presence: true
  validates :shift, inclusion: { in: Classroom.shifts.keys, message: "%{value} is not a valid shift"  }
  validates :week_day, inclusion: { in: OPTIONS_WEEK_DAY, message: "%{value} is not a valid week day" }
end
