# frozen_string_literal: true

module Api
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def create
      @teacher = Teacher.new sign_up_params
      @teacher.save
      if @teacher.errors.empty?
        if params[:organization_attributes].nil?
          sign_in @teacher
          render json: @teacher, include: :role
        else
          create_with_organization
        end
      else
        render json: @teacher.errors, status: :unprocessable_entity
      end
    end

    protected

    def sign_up_params
      params.require(:teacher)
            .permit(:name, :password, :email, :avatar)
            .merge(role: params[:organization_attributes].present? ? Role.find_by!(name: 'ADMIN') : Role.find_by!(name: 'CUSTOMER'))
    end

    def organization_params
      params.require(:organization_attributes)
            .permit(:cnpj, :logo, :name, :phone).merge(teacher_id: @teacher.id)
    end

    def build_organization
      @organization = Organization.new(organization_params)
      @organization.save
    end

    def create_with_organization
      if build_organization
        @teacher.update(organization_id: @organization.id)
        sign_in @teacher
        render json: @teacher, include: [:role, { organization: { include: [:theme] } }]
      else
        @teacher.really_destroy!
        render json: @organization.errors, status: :unprocessable_entity
      end
    end
  end
end
