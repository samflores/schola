# frozen_string_literal: true

Rails.application.routes.draw do
  resources :students
  resources :enrollments, param: :code
  resources :grades
  resources :teachers
  resources :teacher_assignments
  resources :courses
  resources :exams
  resources :subjects

  root 'dashboard#show'
end
