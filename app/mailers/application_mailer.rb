# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'user@default.com'
  layout 'mailer'
end
