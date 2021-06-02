# frozen_string_literal: true

require 'csv'

class Teacher < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::Allowlist
  include GenerateCsv

  has_many :teacher_classrooms
  has_many :classrooms, through: :teacher_classrooms
  has_many :call_lists, through: :classrooms
  has_many :student_answers, through: :call_lists
  has_many :allowlisted_jwts

  devise :database_authenticatable,
         :encryptable,
         :registerable,
         :recoverable,
         :confirmable,
         :validatable,
         :trackable,
         :jwt_authenticatable,
         jwt_revocation_strategy: self
  validates :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].select(&:present?).join(' ').titleize
  end

  def password_salt
    'no salt'
  end

  def password_salt=(new_salt); end
end
