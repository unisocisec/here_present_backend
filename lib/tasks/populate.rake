# frozen_string_literal: true

require 'faker'

namespace :db do
  desc 'Erase and Fill database to develop environment'
  task populate_start: :environment do
    return unless Rails.env.development?

    Faker::Config.locale = 'pt-BR'
    puts 'Create Teachers'
    teacher = Teacher.create_with(
      password: 'password1234', first_name: 'user', last_name: 'default'
    ).where(
      email: 'user@default.com'
    ).first_or_create
    teacher.confirm
    puts 'Create Classrooms'
    2.times do
      classroom = Classroom.where(
        name: Faker::Educator.course_name,
        school: Faker::Educator.university,
        week_day: Classroom::OPTIONS_WEEK_DAY.sample,
        shift: rand(0..2)
      ).first_or_create
      TeacherClassroom.where(teacher_id: teacher.id, classroom_id: classroom.id).first_or_create
      puts 'Create CallLists'
      2.times do |j|
        confirmation_code = Faker::Game.title
        call_list = CallList.where(
          title: "CallList-#{j}",
          date_start: Time.now - 1.day,
          date_end: Time.now + 1.day,
          expired_at: Time.now + 1.week,
          classroom_id: classroom.id,
          confirmation_code: confirmation_code
        ).first_or_create
        puts 'Create StudentAnswers'
        15.times do |w|
          confirmation_code = 'error_code' if w > 4
          StudentAnswer.where(
            full_name: Faker::Games::WorldOfWarcraft.hero,
            email: Faker::Internet.unique.email,
            call_list_id: call_list.id,
            confirmation_code: confirmation_code
          ).first_or_create
        end
      end
    end
  end

  task populate_base: :environment do
    return unless Rails.env.development?

    Faker::Config.locale = 'pt-BR'
    puts 'Create Teachers'
    2.times do
      teacher = Teacher.new(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.unique.email,
        password: 'password1234'
      )
      teacher.confirm
      teacher.save
      puts 'Create Classrooms'
      3.times do
        classroom = Classroom.create(
          name: Faker::Educator.course_name,
          school: Faker::Educator.university,
          week_day: Classroom::OPTIONS_WEEK_DAY.sample,
          shift: rand(0..2)
        )
        TeacherClassroom.create(teacher_id: teacher.id, classroom_id: classroom.id)
        puts 'Create CallLists'
        4.times do |j|
          confirmation_code = Faker::Game.title
          call_list = CallList.create(
            title: "CallList-#{j}",
            date_start: Time.now - 1.day,
            date_end: Time.now + 1.day,
            expired_at: Time.now + 1.week,
            classroom_id: classroom.id,
            confirmation_code: confirmation_code
          )
          puts 'Create StudentAnswers'
          5.times do |w|
            confirmation_code = 'error_code' if w > 4
            StudentAnswer.create(
              full_name: Faker::Games::WorldOfWarcraft.hero,
              email: Faker::Internet.unique.email,
              call_list_id: call_list.id,
              confirmation_code: confirmation_code
            )
          end
        end
      end
    end
  end
end
