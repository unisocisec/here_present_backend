# frozen_string_literal: true

class ApplicationController < ActionController::API
  PAGINATE_PER_PAGE = 12
  before_action :authenticate_teacher!
end
