# frozen_string_literal: true

class CodeValidationsController < ApplicationController
  before_action :load_teacher

  def create
    if @teacher.nil?
      render json: {}, status: :not_found
    else
      token, payload = Warden::JWTAuth::UserEncoder.new.call(@teacher, :credential, nil)
      whitelist = AllowlistedJwt.new(allowlisted_jwt_params(payload))
      whitelist.save
      render json: { token: token }
    end
  end

  protected

  def load_teacher
    @teacher = Teacher.find_by(reset_password_token: code_params)
  end

  def code_params
    params.require(:code)
  end

  def allowlisted_jwt_params(payload)
    {
      teacher_id: @teacher.id,
      jti: payload['jti'],
      exp: Time.zone.at(payload['exp']),
      aud: payload['aud']
    }
  end
end
