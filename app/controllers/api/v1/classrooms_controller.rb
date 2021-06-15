# frozen_string_literal: true

module Api
  module V1
    class ClassroomsController < ApplicationController
      before_action :search_classroom_for_id, except: %w[index create]

      def index
        @classrooms = Classroom.joins(:teachers).where(teachers: { id: current_teacher.id })
        paginate json: @classrooms, status: :ok
      end

      def show
        render json: { classroom: @classroom, message: I18n.t('show_record_found') }, status: :ok
      end

      def create
        @classroom = Classroom.new(create_params)
        if @classroom.save
          TeacherClassroom.create(teacher_id: current_teacher.id, classroom_id: @classroom.id)
          render json: { classroom: @classroom, message: I18n.t('success.create.classroom') }, status: :created
        else
          error_message = ''
          @classroom.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @classroom.errors.messages, error_message: error_message }, status: :unprocessable_entity
        end
      end

      def update
        if @classroom.update(update_params)
          render json: { classroom: @classroom }, status: :ok
        else
          error_message = ''
          @classroom.errors.full_messages.each do |value_error|
            error_message += "#{value_error}. "
          end
          render json: { errors: @classroom.errors.messages, error_message: error_message }, status: :unprocessable_entity
        end
      end

      def add_teacher_in_classroom
        @teacher_add = Teacher.find_by_email(params[:teacher_email])
        return render json: { message: I18n.t('not_find_teacher_with_email') }, status: :bad_request if @teacher_add.blank?

        @teacher_classroom = TeacherClassroom.new(classroom_id: @classroom.id, teacher_id: @teacher_add&.id)
        if @teacher_classroom.save
          render json: { message: I18n.t('successful_teacher_addition'), teacher_add: @teacher_add }, status: :ok
        else
          render json: { message: I18n.t('error_adding_teacher') }, status: :bad_request
        end
      end

      def destroy
        if @classroom.destroy
          render json: { message: I18n.t('success.destroy.classroom'), classroom: @classroom }, status: :ok
        else
          render json: { message: I18n.t('error.destroy.classroom') }, status: :bad_request
        end
      end

      def classroom_teachers
        @teachers = @classroom.teachers
        paginate json: @teachers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def classroom_call_lists
        @call_lists = @classroom.call_lists
        paginate json: @call_lists, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def classroom_student_answers
        @student_answers = @classroom.student_answers
        paginate json: @student_answers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def export_teachers_in_classroom
        response = export_service.export_teachers(teachers: @classroom.teachers)
        render json: { message: response[:message], path: response[:path], current_classroom: @classroom }, status: response[:status]
      end

      def export_call_lists_in_classroom
        response = export_service.export_call_lists(call_lists: @classroom.call_list)
        render json: { message: response[:message], path: response[:path], current_classroom: @classroom }, status: response[:status]
      end

      def export_student_answers_in_classroom
        response = export_service.export_student_answers(student_answers: @classroom.student_answers)
        render json: { message: response[:message], path: response[:path], current_classroom: @classroom }, status: response[:status]
      end

      private

      def export_service
        @export_service ||= ExportService.new
      end

      def search_classroom_for_id
        @classroom = Classroom.joins(:teachers).where(id: params[:id], teachers: { id: current_teacher.id }).first
        return render json: { message: I18n.t('messages.dont_find.classroom') }, status: :bad_request if @classroom.blank?

        @classroom.translation_columns unless params[:action] == 'update'
        @classroom
      end

      def create_params
        params.permit(
          :name,
          :school,
          :shift,
          weekdays: []
        )
      end

      def update_params
        params.permit(
          :name,
          :school,
          :shift,
          weekdays: []
        )
      end
    end
  end
end
