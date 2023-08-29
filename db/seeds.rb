# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'securerandom'

%w[Matemática Português História Geografia Física Química Inglês].each { |subject| Subject.create(name: subject) }

5.times { |_| FactoryBot.create(:teacher) }
teachers = Teacher.all
subjects = Subject.all
random_student_number = rand(20..40)

# Para 2012:
(5..9).to_a.each do |grade|
  Course.create(year: 2012, name: "#{grade}º ano", starts_on: '2012-01-01', ends_on: '2012-12-31')
end

2012_courses = Course.where(year: 2012)

2012_courses.each do |course|
  random_student_number.times do
    course.enrollments.create(code: SecureRandom.uuid, student: FactoryBot.create(:student))
  end

  subjects.each do |subject|
    course.teacher_assignments.create(course:, subject:, teacher: teachers.sample)
  end
end

Enrollment.all.each do |enrollment|
  subjects.each do |subject|
    8.times do
      Grade.create(value: rand(0..10), enrollment:,
                   exam: Exam.new(course: enrollment.course, subject:, realized_on: FFaker::Time.between(Date.new(2012, 1, 1), Date.new(2012, 12, 31)).to_date))
    end
  end
end
