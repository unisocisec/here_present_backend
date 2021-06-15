# frozen_string_literal: true

module Api
  module V1
    class TeachersController < ApplicationController
      skip_before_action :authenticate_teacher!, only: [:create]
      before_action :search_teacher_for_id, except: %w[index create]

      def index
        return render json: { message: I18n.t('not_have_permission') }, status: :forbidden unless current_teacher.email == ENV['USER_ADMIN']

        @teachers = Teacher.all
        paginate json: { teachers: @teachers }, status: :ok
      end

      def show
        render json: { teacher: @teacher, message: I18n.t('show_record_found') }, status: :ok
      end

      def create
        @teacher = Teacher.new(create_params)
        if @teacher.save
          render json: { teacher: @teacher, message: I18n.t('record_created_successfully') }, status: :created
        else
          error_message = ''
          @teacher.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @teacher.errors.messages, error_message: error_message }, status: :bad_request
        end
      end

      def update
        if @teacher.update(update_params)
          render json: { teacher: @teacher }, status: :ok
        else
          error_message = ''
          @teacher.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @teacher.errors.messages, error_message: error_message }, status: :bad_request
        end
      end

      def destroy
        return render json: { message: I18n.t('error_password_delete_teacher') } unless @teacher.valid_password?(params[:teacher_password])

        if @teacher.destroy
          render json: { message: I18n.t('success.destroy.teacher') }, status: :ok
        else
          render json: { message: I18n.t('error.destroy.teacher') }, status: :bad_request
        end
      end

      def teacher_classrooms
        @classrooms = @teacher.classrooms
        @classrooms.map do |classroom|
          classroom.student_count = classroom.student_answers.count
        end
        render json: @classrooms, methods: [:student_count], status: :ok
      end

      def teacher_call_lists
        @call_lists = @teacher.call_lists
        paginate json: @call_lists, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def teacher_student_answers
        @student_answers = @teacher.student_answers
        paginate json: @student_answers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def export_classrooms_in_teacher
        response = export_service.export_classrooms(classrooms: @teacher.classrooms)
        render json: { message: response[:message], path: response[:path], current_teacher: @teacher }, status: response[:status]
      end

      def export_call_lists_in_teacher
        response = export_service.export_call_lists(call_lists: @teacher.call_lists)
        render json: { message: response[:message], path: response[:path], current_teacher: @teacher }, status: response[:status]
      end

      def export_student_answers_in_teacher
        response = export_service.export_student_answers(student_answers: @teacher.student_answers)
        render json: { message: response[:message], path: response[:path], current_teacher: @teacher }, status: response[:status]
      end

      private

      def export_service
        @export_service ||= ExportService.new
      end

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
        return render json: { message: I18n.t('messages.dont_find.teacher') }, status: :bad_request if @teacher.blank?

        @teacher
      end
    end
  end
end
