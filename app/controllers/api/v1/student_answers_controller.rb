# frozen_string_literal: true

module Api
  module V1
    class StudentAnswersController < ApplicationController
      def index
        @student_answers = StudentAnswer.all
        render json: @student_answers
      end

      def show
        @student_answer = StudentAnswer.find_by_id(params[:id])
        if @student_answer.present?
          render json: @student_answer
        else
          render json: { message: 'Não foi possível identificar Turma com esse ID' }, status: :bad_request
        end
      end

      def create
        @student_answer = StudentAnswer.new(create_params)
        if @student_answer.save
          render json: @student_answer, status: :created
        else
          render json: @student_answer.errors, status: :unprocessable_entity
        end
      end

      def update
        @student_answer = StudentAnswer.find_by_id(params[:id])
        if @student_answer.update(update_params)
          render json: @student_answer
        else
          render json: @student_answer.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @student_answer = StudentAnswer.find_by_id(params[:id])
        if @student_answer.destroy
          render json: { message: 'Exclusão com sucesso' }, status: :ok
        else
          render json: { message: 'Exclusão com error' }, status: :bad_request
        end
      end

      private

      def create_params
        params.permit(
          :full_name,
          :email,
          :confirmation_code,
          :call_list_id
        )
      end

      def update_params
        params.permit(
          :full_name,
          :email,
          :confirmation_code
        )
      end
    end
  end
end
