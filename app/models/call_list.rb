# frozen_string_literal: true

class CallList < ApplicationRecord
  validates :title, :confirmation_token, presence: true
end
