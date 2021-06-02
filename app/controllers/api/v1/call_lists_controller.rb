# frozen_string_literal: true

module Api
  module V1
    class CallListsController < ApplicationController
      before_action :search_call_list_for_id, except: %w[index create]

      def index
        @call_lists = CallList.joins(:teachers).where(teachers: { id: current_teacher.id })
        render json: @call_lists
      end

      def show
        render json: @call_list
      end

      def create
        @call_list = CallList.new(create_params)
        if @call_list.save
          render json: @call_list, status: :created
        else
          render json: @call_list.errors, status: :unprocessable_entity
        end
      end

      def update
        if @call_list.update(update_params)
          render json: @call_list
        else
          render json: @call_list.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @call_list.destroy
          render json: { message: 'Exclusão com sucesso' }, status: :ok
        else
          render json: { message: 'Exclusão com error' }, status: :bad_request
        end
      end

      def call_list_teachers
        @teachers = @call_list.teachers
        paginate json: @teachers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      def call_list_classroom
        @classroom = @call_list.classroom
        render json: { classroom: @classroom }
      end

      def call_list_student_answers
        @student_answers = @call_list.student_answers
        paginate json: @student_answers, per_page: PAGINATE_PER_PAGE, status: :ok
      end

      private

      def search_call_list_for_id
        @call_list = CallList.joins(:teachers).where(id: params[:id], teachers: { id: current_teacher.id }).first
        return render json: { message: 'Não foi possível encontrar a Chamada' }, status: :bad_request if @call_list.blank?

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
