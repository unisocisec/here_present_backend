# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3', '~> 1.4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'api-pagination'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'csv'
gem 'devise'
gem 'devise-argon2'
gem 'devise-encryptable'
gem 'devise-i18n'
gem 'devise-jwt'
gem 'faker'
gem 'ffi'
gem 'listen'
gem 'minitest'
gem 'pg'
gem 'puma'
gem 'rack-attack'
gem 'rack-cors'
gem 'rails-i18n'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'will_paginate'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  # gem 'simplecov'
  # gem 'standard'
end

group :development do
  gem 'mailcatcher'
  gem 'spring'
end
