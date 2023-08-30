# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# TODO: otimizar com insert_all
require 'securerandom'

%w[Matemática Português História Geografia Física Química Inglês].each { |subject| Subject.create!(name: subject) }

5.times { |_| FactoryBot.create(:teacher) }

teachers = Teacher.all
subjects = Subject.all

# Para 2012:
courses = (5..9).to_a.map do |grade|
  { year: 2012, name: "#{grade}º ano", starts_on: '2012-01-01', ends_on: '2012-12-31' }
end

Course.insert_all(courses)

courses2012 = Course.where(year: 2012)

courses2012.each do |course|
  rand(20..40).times do
    course.enrollments.create!(code: SecureRandom.uuid, student: FactoryBot.create(:student))
  end

  subjects.each do |subject|
    course.teacher_assignments.create!(course:, subject:, teacher: teachers.sample)
  end
end

Enrollment.all.map do |enrollment|
  subjects.map do |subject|
    8.times do
      Grade.new(value: rand(0..10), enrollment:,
                exam: Exam.new(course: enrollment.course, subject:, realized_on: FFaker::Time.between(Date.new(2012, 1, 1), Date.new(2012, 12, 31)).to_date))
    end
  end
end

# Para 2013:

# Criando os cursos de 2013
(5..9).to_a.each do |grade|
  Course.create(year: 2013, name: "#{grade}º ano", starts_on: '2013-01-01', ends_on: '2013-12-31')
end

# Matriculando alunos novos no 5º ano
rand(20..40).times do
  Course.where(year: 2013, name: '5º ano').first.enrollments.create!(code: SecureRandom.uuid,
                                                                     student: FactoryBot.create(:student))
end

# Criando matrícula do curso seguinte para os alunos do 5º ao 8º ano:
(5..8).to_a.each do |year|
  Course.where(year: 2012, name: "#{year}º ano").first.students.each do |student|
    Enrollment.create!(code: SecureRandom.uuid, student:,
                       course: Course.where(year: 2013, name: "#{year + 1}º ano").first)
  end
end

courses2013 = Course.where(year: 2013)

courses2013.each do |course|
  subjects.each do |subject|
    course.teacher_assignments.create!(course:, subject:, teacher: teachers.sample)
  end
end

Course.where(year: 2013).each do |course|
  course.enrollments.each do |enrollment|
    subjects.each do |subject|
      8.times do
        Grade.create!(value: rand(0..10), enrollment:,
                      exam: Exam.new(course: enrollment.course, subject:, realized_on: FFaker::Time.between(Date.new(2012, 1, 1), Date.new(2012, 12, 31)).to_date))
      end
    end
  end
end
