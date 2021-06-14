# frozen_string_literal: true

module Api
  module V1
    class StudentAnswersController < ApplicationController
      skip_before_action :authenticate_teacher!, only: [:create]
      before_action :search_student_answer_for_id, except: %w[index create]

      def index
        @student_answers = StudentAnswer.joins(:teachers).where(teachers: { id: current_teacher.id })
        paginate json: @student_answers, status: :ok
      end

      def show
        render json: { student_answer: @student_answer, message: I18n.t('show_record_found') }, status: :ok
      end

      def create
        @student_answer = StudentAnswer.new(create_params)
        if @student_answer.save
          render json: { student_answer: @student_answer, message: I18n.t('success.create.student_answer') }, status: :created
        else
          error_message = ""
          @call_list.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @student_answer.errors.messages, error_message: error_message }, status: :unprocessable_entity
        end
      end

      def update
        if @student_answer.update(update_params)
          render json: { student_answer: @student_answer }, status: :ok
        else
          error_message = ""
          @call_list.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @student_answer.errors.messages, error_message: error_message }, status: :unprocessable_entity
        end
      end

      def destroy
        if @student_answer.destroy
          render json: { message: I18n.t('success.destroy.student_answer') }, status: :ok
        else
          render json: { message: I18n.t('error.destroy.student_answer') }, status: :bad_request
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
        return render json: { message: I18n.t('messages.dont_find.student_answer') }, status: :bad_request if @student_answer.blank?

        @student_answer
      end

      def create_params
        params.permit(
          :full_name,
          :email,
          :confirmation_code,
          :documentation,
          :call_list_id
        )
      end

      def update_params
        params.permit(
          :full_name,
          :email,
          :documentation,
          :confirmation_code
        )
      end
    end
  end
end
