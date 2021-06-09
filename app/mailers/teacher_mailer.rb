# frozen_string_literal: true

class TeacherMailer < ApplicationMailer
  before_action :load_teacher

  def welcome
    @subject = I18n.t('mailer.subject.welcome')
    mail to: @teacher.email, subject: @subject
  end

  def password_reset_code
    @subject = I18n.t('mailer.subject.password_reset_code')
    mail to: @teacher.email, subject: @subject
  end

  protected

  def load_teacher
    @teacher = params[:teacher]
    @code = params[:code]
    @generated_password = params[:generated_password]
  end
end
