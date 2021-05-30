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
      resources :teachers do
        get :teacher_classrooms, on: :member
        get :teacher_call_lists, on: :member
        get :teacher_student_answers, on: :member
      end
      resources :classrooms do
        post :add_teacher_in_classroom, on: :member
        get :classroom_teachers, on: :member
        get :classroom_call_lists, on: :member
        get :classroom_student_answers, on: :member
      end
      resources :call_lists do
        get :call_list_teachers, on: :member
        get :call_list_classroom, on: :member
        get :call_list_student_answers, on: :member
      end
      resources :student_answers do
        get :student_answer_teachers, on: :member
        get :student_answer_classroom, on: :member
        get :student_answer_call_lists, on: :member
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
