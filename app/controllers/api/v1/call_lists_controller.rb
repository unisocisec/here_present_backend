# frozen_string_literal: true

module Api
  module V1
    class CallListsController < ApplicationController
      skip_before_action :authenticate_teacher!, only: [:get_classroom_name]
      before_action :search_call_list_for_id, except: %w[index create get_classroom_name]

      def index
        @call_lists = CallList.joins(:teachers).where(teachers: { id: current_teacher.id })
        paginate json: { call_lists: @call_lists }, status: :ok
      end

      def show
        render json: { call_list: @call_list, token_call_list: @call_list.token_encode, message: I18n.t('show_record_found') }, status: :ok
      end

      def create
        @call_list = CallList.new(create_params)
        if @call_list.save
          render json: { call_list: @call_list, message: I18n.t('success.create.call_list') }, status: :created
        else
          error_message = ''
          @call_list.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @call_list.messages, error_message: error_message }, status: :unprocessable_entity
        end
      end

      def update
        if @call_list.update(update_params)
          render json: { call_list: @call_list }, status: :ok
        else
          error_message = ''
          @call_list.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @call_list.errors.messages, error_message: error_message }, status: :unprocessable_entity
        end
      end

      def destroy
        if @call_list.destroy
          render json: { message: I18n.t('success.destroy.call_list') }, status: :ok
        else
          render json: { message: I18n.t('error.destroy.call_list') }, status: :bad_request
        end
      end

      def get_classroom_name
        @call_list = CallList.get_call_list_through_token(token_call_list_id: params[:token_call_list_id])
        if @call_list.present?
          render json: { classroom_name: @call_list.classroom.name }, status: :ok
        else
          render json: { classroom_name: I18n.t('messages.dont_find.classroom') }, status: :bad_request
        end
      end

      def call_list_teachers
        @teachers = @call_list.teachers
        paginate json: @teachers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def call_list_classroom
        @classroom = @call_list.classroom
        render json: { classroom: @classroom }, status: :ok
      end

      def call_list_student_answers
        @student_answers = @call_list.student_answers
        paginate json: @student_answers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def export_teachers_in_call_list
        response = export_service.export_teachers(teachers: @call_list.teachers)
        render json: { message: response[:message], path: response[:path], current_call_list: @call_list }, status: response[:status]
      end

      def export_student_answers_in_call_list
        response = export_service.export_student_answers(student_answers: @call_list.student_answers)
        render json: { message: response[:message], path: response[:path], current_call_list: @call_list }, status: response[:status]
      end

      private

      def export_service
        @export_service ||= ExportService.new
      end

      def search_call_list_for_id
        @call_list = CallList.joins(:teachers).where(id: params[:id], teachers: { id: current_teacher.id }).first
        return render json: { message: I18n.t('messages.dont_find.call_list') }, status: :bad_request if @call_list.blank?

        @call_list
      end

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
