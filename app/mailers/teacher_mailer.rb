# frozen_string_literal: true

class TeacherMailer < ApplicationMailer
  before_action :load_teacher

  def welcome
    @subject = t('welcome.subject')
    mail to: @teacher.email, subject: @subject
  end

  def password_reset_code
    @subject = 'Código de verificação - Here Present'
    mail to: @teacher.email, subject: @subject
  end

  protected

  def load_teacher
    @teacher = params[:teacher]
    @code = params[:code]
    @generated_password = params[:generated_password]
  end
end
