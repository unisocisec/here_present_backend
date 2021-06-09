# frozen_string_literal: true

module Api
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      @teacher = Teacher.new(sign_up_params)
      if @teacher.save
        sign_in @teacher
        render json: @teacher, status: :ok
      else
        render json: @teacher.errors, status: :unprocessable_entity
      end
    end

    protected

    def sign_up_params
      params.require(:name, :password, :email)
    end
  end
end
