# frozen_string_literal: true

module Api
  class PasswordsController < Devise::PasswordsController
    before_action :find_teacher

    def create
      if @teacher.nil?
        render json: {}, status: :not_found
      else
        code = @teacher.generate_code
        @teacher.reset_password_token = code
        @teacher.reset_password_sent_at = Time.now.utc
        @teacher.save
        # UserMailer.with(user: @teacher, code: code).password_reset_code.deliver_now!
        render json: {}, status: :ok
      end
    end

    protected

    def find_teacher
      @teacher = Teacher.find_by_email(required_params)
    end

    def required_params
      params.require(:email)
    end
  end
end
