# frozen_string_literal: true

module Api
  module V1
    class TeachersController < ApplicationController
      before_action :search_teacher_for_id, only: %i[show update my_classrooms destroy]

      def index
        @teachers = Teacher.all
        render json: @teachers
      end

      def show
        render json: @teacher
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
        if @teacher.update(update_params)
          render json: @teacher
        else
          render json: @teacher.errors, status: :unprocessable_entity
        end
      end

      def my_classrooms
        @my_classrooms = @teacher.classrooms
        render json: { classrooms: @my_classrooms }, status: :ok
      end

      def destroy
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

      def search_teacher_for_id
        @teacher = Teacher.find_by_id(params[:id].to_i)
        return render json: { message: 'Não foi possível encontrar o professor' }, status: :bad_request if @teacher.blank?

        @teacher
      end
    end
  end
end
