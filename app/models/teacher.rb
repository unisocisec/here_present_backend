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

  def self.column_names_to_export
    export_columns = attribute_names - reject_attributes
    export_columns.map { |column| human_attribute_name(column) }
  end

  def self.reject_attributes
    %w[
      encrypted_password reset_password_token reset_password_sent_at remember_created_at
      sign_in_count current_sign_in_at last_sign_in_at current_sign_in_ip last_sign_in_ip
      confirmation_token confirmed_at confirmation_sent_at unconfirmed_email failed_attempts
      unlock_token locked_at updated_at
    ]
  end

  def export_attributes
    attributes.except!(
      'encrypted_password', 'reset_password_token', 'reset_password_sent_at', 'remember_created_at',
      'sign_in_count', 'current_sign_in_at', 'last_sign_in_at', 'current_sign_in_ip', 'last_sign_in_ip',
      'confirmation_token', 'confirmed_at', 'confirmation_sent_at', 'unconfirmed_email', 'failed_attempts',
      'unlock_token', 'locked_at', 'updated_at'
    )
  end

  def password_salt=(new_salt); end
end
