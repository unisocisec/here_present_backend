# frozen_string_literal: true

module Api
  module V1
    class TeachersController < ApplicationController
      skip_before_action :authenticate_teacher!, only: [:create]
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

      def destroy
        if @teacher.destroy
          render json: { message: 'Exclusão com sucesso' }, status: :ok
        else
          render json: { message: 'Exclusão com error' }, status: :bad_request
        end
      end

      def teacher_classrooms
        @classrooms = @teacher.classrooms
        paginate json: @classrooms, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def teacher_call_lists
        @call_lists = @teacher.call_lists
        paginate json: @call_lists, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def teacher_student_answers
        @student_answers = @teacher.student_answers
        paginate json: @student_answers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def export_teachers
        @teachers = Teacher.all

        # byebug
        # file_name = "export_teachers"
        # path = FileUtils.mkdir_p "public/uploads/exports/#{Time.now.strftime('%Y-%d-%m')}"
        # file = File.open(("#{path.first}/#{Time.now.strftime('%Y-%d-%m')}-#{file_name}#{Time.now.to_i}-#{SecureRandom.uuid}.csv").to_s, "wb:iso-8859-15")
        # file.binmode
        # file.write(@teachers.to_csv)
        # file.close
        # file.path

        render json: { student_answers: @student_answers }, status: :ok
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
