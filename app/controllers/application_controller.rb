# frozen_string_literal: true

class ApplicationController < ActionController::API
  PAGINATE_PER_PAGE = 20
  before_action :authenticate_teacher!
end
