# frozen_string_literal: true

module Api
  module V1
    class ClassroomsController < ApplicationController
      before_action :search_classroom_for_id, except: %w[index create]

      def index
        @classrooms = Classroom.all
        render json: { classrooms: @classrooms }
      end

      def show
        render json: { classroom: @classroom, message: 'registro encontrado' }
      end

      def create
        @classroom = Classroom.new(create_params)
        if @classroom.save
          render json: { classroom: @classroom, message: 'Turma criada com sucesso' }, status: :created
        else
          render json: @classroom.errors, status: :unprocessable_entity
        end
      end

      def update
        if @classroom.update(update_params)
          render json: @classroom
        else
          render json: @classroom.errors, status: :unprocessable_entity
        end
      end

      def add_teacher_in_classroom
        @teacher_add = Teacher.find_by_email(params[:teacher_email])
        return render json: { message: 'Não foi possível encontrar um professor com esse email' }, status: :bad_request if @teacher_add.blank?

        @teacher_classroom = TeacherClassroom.new(classroom_id: params[:classroom_id], teacher_id: @teacher_add&.id)
        if @teacher_classroom.save
          render json: { message: 'Adição do professor com sucesso', teacher_add: @teacher_add }, status: :ok
        else
          render json: { message: 'Erro ao adicionar o professor' }, status: :bad_request
        end
      end

      def destroy
        if @classroom.destroy
          render json: { message: 'Exclusão com sucesso', classroom: @classroom }, status: :ok
        else
          render json: { message: 'Exclusão com error' }, status: :bad_request
        end
      end

      def classroom_teachers
        @teachers = @classroom.teachers
        render json: { teachers: @teachers }
      end

      def classroom_call_lists
        @call_lists = @classroom.call_lists
        render json: { call_lists: @call_lists }
      end

      def classroom_student_answers
        @student_answers = @classroom.student_answers
        render json: { student_answers: @student_answers }
      end

      private

      def search_classroom_for_id
        @classroom = Classroom.find_by_id(params[:id])
        return render json: { message: 'Não foi possível encontrar a Turma' }, status: :bad_request if @classroom.blank?

        @classroom
      end

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
