# frozen_string_literal: true

module Api
  module V1
    class TeachersController < ApplicationController
      load_and_authorize_resource

      def index
        render json: { status: 200, message: 'OIII' }
        # render json: current_resource_owner.as_json
      end

      def update
        render json: { result: current_resource_owner.touch(:updated_at) }
      end
    end
  end
end
