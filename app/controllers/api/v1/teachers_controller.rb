# frozen_string_literal: true

module Api
  module V1
    class TeachersController < ApplicationController
      before_action :authenticate_teacher!

      def index
        @teachers = Teacher.all
        render json: @teachers
      end

      def show
        @teacher = Teacher.find_by_id(params[:id])
        if @teacher.present?
          render json: @teacher
        else
          render json: { message: 'Não foi possível identeficar usuario com esse ID' }, status: :bad_request
        end
      end

      def create
        @teacher = Teacher.new(create_params)
        if @teacher.save
          render json: @teacher, status: :created
        else
          render json: @teacher.errors, status: :unprocessable_entity
        end
      end

      def update
        @teacher = Teacher.find_by_id(params[:id])
        if @teacher.update(update_params)
          render json: @teacher
        else
          render json: @teacher.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @teacher = Teacher.find_by_id(params[:id])
        if @teacher.destroy
          render json: { message: 'Exclusão com sucesso' }, status: :ok
        else
          render json: { message: 'Exclusão com error' }, status: :bad_request
        end
      end

      private

      def create_params
        params.permit(
          :email,
          :first_name,
          :last_name,
          :password
        )
      end

      def update_params
        params.permit(
          :first_name,
          :last_name
        )
      end
    end
  end
end
