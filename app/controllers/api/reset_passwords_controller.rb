# frozen_string_literal: true

module Api
  class ResetPasswordsController < ApplicationController

    def update
      if current_teacher.update(reset_params)
        render json: { current_teacher: current_teacher }, status: :ok
      else
        render json: { errors: current_teacher.errors }, status: :unprocessable_entity
      end
    end

    protected

    def reset_params
      params.require(:reset_params).permit(:password)
    end
  end
end
