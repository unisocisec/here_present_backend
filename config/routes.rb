# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :sessions, only: [:new, :create]
  devise_for :teachers, path: 'auth',
                        defaults: { format: :json },
                        path_names: {
                          registration: 'sign_up',
                          confirmation: 'confirmations'
                        },
                        controllers: {
                          confirmations: 'api/confirmations',
                          unlocks: 'unlocks',
                          passwords: 'api/passwords',
                          sessions: 'api/sessions',
                          registrations: 'api/registrations'
                        }

  post 'auth/code' => 'api/code_validations#create'
  put 'auth/reset_passwords' => 'api/reset_passwords#update'

  namespace :api do
    namespace :v1 do
      resources :classrooms do
        get :teachers_in_classroom, on: :member
        post :add_teacher_in_classroom, on: :member
      end
      resources :call_lists
      resources :teachers do
        get :my_classrooms, on: :member
      end
      resources :student_answers
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
