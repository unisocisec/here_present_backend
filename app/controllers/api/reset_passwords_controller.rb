# frozen_string_literal: true

class ResetPasswordsController < ApplicationController
  authorize_resource class: Teacher

  def update
    if current_teacher.update(reset_params)
      render json: current_teacher, include: [:role, { organization: { include: [:theme] } }]
    else
      render json: current_teacher.errors, status: :unprocessable_entity
    end
  end

  protected

  def reset_params
    params.require(:reset_params).permit(:password)
  end
end
