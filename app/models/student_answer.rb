# frozen_string_literal: true

class StudentAnswer < ApplicationRecord
  validates :title, :confirmation_token, presence: true
end
