# frozen_string_literal: true

module Api
  module V1
    class StudentAnswersController < ApplicationController
      skip_before_action :authenticate_teacher!, only: [:create]
      before_action :search_student_answer_for_id, except: %w[index create]

      def index
        @student_answers = StudentAnswer.joins(:teachers).where(teachers: { id: current_teacher.id })
        render json: @student_answers
      end

      def show
        render json: @student_answer
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
        if @student_answer.update(update_params)
          render json: @student_answer
        else
          render json: @student_answer.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @student_answer.destroy
          render json: { message: 'Exclusão com sucesso' }, status: :ok
        else
          render json: { message: 'Exclusão com error' }, status: :bad_request
        end
      end

      def student_answer_teachers
        @teachers = @student_answer.teachers
        paginate json: @teachers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def student_answer_classroom
        @classroom = @student_answer.classroom
        render json: { classroom: @classroom }, status: :ok
      end

      def student_answer_call_list
        @call_list = @student_answer.call_list
        render json: { call_list: @call_list }, status: :ok
      end

      private

      def search_student_answer_for_id
        @student_answer = StudentAnswer.joins(:teachers).where(id: params[:id], teachers: { id: current_teacher.id }).first
        return render json: { message: 'Não foi possível encontrar a(o) Estudante' }, status: :bad_request if @student_answer.blank?

        @student_answer
      end

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
