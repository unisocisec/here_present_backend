# frozen_string_literal: true

module Api
  class SessionsController < Devise::SessionsController
    wrap_parameters :teacher
    respond_to :json

    private

    def sign_in_params
      params.permit(:email, :password)
    end
  end
end
