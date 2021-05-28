# frozen_string_literal: true

module Api
  module V1
    class CallListsController < ApplicationController
      def index
        @call_lists = CallList.all
        render json: @call_lists
      end

      def show
        @call_list = CallList.find_by_id(params[:id])
        if @call_list.present?
          render json: @call_list
        else
          render json: { message: "Não foi possível identificar Turma com esse ID" }, status: :bad_request
        end
      end

      def create
        @call_list = CallList.new(create_params)
        if @call_list.save
          render json: @call_list, status: :created
        else
          render json: @call_list.errors, status: :unprocessable_entity
        end
      end

      def update
        @call_list = CallList.find_by_id(params[:id])
        if @call_list.update(update_params)
          render json: @call_list
        else
          render json: @call_list.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @call_list = CallList.find_by_id(params[:id])
        if @call_list.destroy
          render json: { message: "Exclusão com sucesso" }, status: :ok
        else
          render json: { message: "Exclusão com error" }, status: :bad_request
        end
      end

      private

      def create_params
        params.permit(
          :title,
          :date_start,
          :date_end,
          :expired_at,
          :classroom_id,
          :confirmation_code
        )
      end

      def update_params
        params.permit(
          :title,
          :date_start,
          :date_end,
          :expired_at,
          :confirmation_code
        )
      end
    end
  end
end
