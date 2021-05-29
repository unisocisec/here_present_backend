# frozen_string_literal: true

module Api
  class SessionsController < Devise::SessionsController
    wrap_parameters :teacher
    respond_to :json

    def new
      render json: {response: "Authentication required"}, status: 401
    end

    private

    def respond_with(resource, _opts = {})
      render json: resource
    end

    def respond_to_on_destroy
      head :ok
    end

    def sign_in_params
      params.permit(:email, :password)
    end
  end
end
