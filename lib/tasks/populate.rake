# frozen_string_literal: true

require 'faker'

def find_or_create_teacher
  Teacher.create_with(
    password: 'password1234', first_name: 'user', last_name: 'default', confirmed_at: Time.now
  ).where(
    email: 'user@default.com'
  ).first_or_create
end

def find_or_create_classroom(teacher_id:)
  weekdays = [Classroom::OPTIONS_WEEKDAYS.sample, Classroom::OPTIONS_WEEKDAYS.sample, Classroom::OPTIONS_WEEKDAYS.sample] if teacher_id.even?
  classroom = Classroom.where(
    name: Faker::Educator.course_name,
    school: Faker::Educator.university,
    weekdays: weekdays || [Classroom::OPTIONS_WEEKDAYS.sample],
    shift: Classroom::OPTIONS_SHIFT.sample
  ).first_or_create
  TeacherClassroom.where(teacher_id: teacher_id, classroom_id: classroom.id).first_or_create
  classroom
end

def find_or_create_call_list(classroom_id:, number:)
  @confirmation_code = Faker::Game.title
  CallList.where(
    title: "CallList-#{number}",
    date_start: Time.now - 1.day,
    date_end: Time.now + 1.day,
    expired_at: Time.now + 1.week,
    classroom_id: classroom_id,
    confirmation_code: @confirmation_code
  ).first_or_create
end

def find_or_create_student_answer(call_list_id:, number:)
  @confirmation_code = 'error_code' if number > 4
  StudentAnswer.where(
    full_name: Faker::Games::WorldOfWarcraft.hero,
    email: Faker::Internet.unique.email,
    call_list_id: call_list_id,
    documentation: Faker::Code.nric,
    confirmation_code: @confirmation_code
  ).first_or_create
end

def create_news_teachers
  teacher = Teacher.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: 'password1234'
  )
  teacher.confirm
  teacher.save
  teacher
end

namespace :db do
  desc 'Erase and Fill database to develop environment'
  task populate_start: :environment do
    Faker::Config.locale = 'pt-BR'

    puts 'Create Teachers, Classrooms, CallLists, StudentAnswers'
    teacher = find_or_create_teacher
    2.times do
      classroom = find_or_create_classroom(teacher_id: teacher.id)
      2.times do |j|
        call_list = find_or_create_call_list(classroom_id: classroom.id, number: j)
        15.times do |w|
          find_or_create_student_answer(call_list_id: call_list.id, number: w)
        end
      end
    end
  end

  task populate_base: :environment do
    Faker::Config.locale = 'pt-BR'
    return 'Only in development environment !' unless Rails.env.development?

    puts 'Create Teachers, Classrooms, CallLists, StudentAnswers'
    2.times do
      teacher = create_news_teachers
      3.times do
        classroom = find_or_create_classroom(teacher_id: teacher.id)
        4.times do |j|
          call_list = find_or_create_call_list(classroom_id: classroom.id, number: j)
          5.times do |w|
            find_or_create_student_answer(call_list_id: call_list.id, number: w)
          end
        end
      end
    end
  end
end
