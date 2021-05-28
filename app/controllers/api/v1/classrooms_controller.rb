# frozen_string_literal: true

module Api
  module V1
    class ClassroomsController < ApplicationController
      def index
        @classrooms = Classroom.all
        render json: @classrooms
      end

      def show
        @classroom = Classroom.find_by_id(params[:id])
        if @classroom.present?
          render json: @classroom
        else
          render json: { message: "Não foi possível identificar Turma com esse ID" }, status: :bad_request
        end
      end

      def create
        @classroom = Classroom.new(create_params)
        if @classroom.save
          render json: @classroom, status: :created
        else
          render json: @classroom.errors, status: :unprocessable_entity
        end
      end

      def update
        @classroom = Classroom.find_by_id(params[:id])
        if @classroom.update(update_params)
          render json: @classroom
        else
          render json: @classroom.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @classroom = Classroom.find_by_id(params[:id])
        if @classroom.destroy
          render json: { message: "Exclusão com sucesso" }, status: :ok
        else
          render json: { message: "Exclusão com error" }, status: :bad_request
        end
      end

      private

      def create_params
        params.permit(
          :name,
          :school,
          :week_day,
          :shift
        )
      end

      def update_params
        params.permit(
          :name,
          :school,
          :week_day,
          :shift
        )
      end
    end
  end
end
