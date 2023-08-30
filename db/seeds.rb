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
end

teacher_assignments = courses2012.map do |course|
  subjects.map do |subject|
    { course_id: course.id, subject_id: subject.id,
      teacher_id: teachers.sample.id }
  end
end

TeacherAssignment.insert_all(teacher_assignments.flatten)

exams2012 = courses2012.map do |course|
  subjects.map do |subject|
    { course_id: course.id, subject_id: subject.id,
      realized_on: FFaker::Time.between(Date.new(2012, 1, 1), Date.new(2012, 12, 31)).to_s }
  end
end

Exam.insert_all(exams2012.flatten)

grades2012 = courses2012.map do |course|
  course.enrollments.map do |enrollment|
    course.exams.map do |exam|
      exams = []
      8.times do
        exams.push({ value: rand(0..10), enrollment_code: enrollment.code, exam_id: exam.id })
      end
      exams
    end
  end
end

Grade.insert_all(grades2012.flatten)

# Para 2013:

# Criando os cursos de 2013
courses2013 = (5..9).to_a.map do |grade|
  { year: 2013, name: "#{grade}º ano", starts_on: '2013-01-01', ends_on: '2013-12-31' }
end

Course.insert_all(courses2013)

# Matriculando alunos novos no 5º ano
rand(20..40).times do
  Course.where(year: 2013, name: '5º ano').first.enrollments.create!(code: SecureRandom.uuid,
                                                                     student: FactoryBot.create(:student))
end

# Criando matrícula do curso seguinte para os alunos do 5º ao 8º ano:
enrollments2013 = (5..8).to_a.map do |year|
  Course.where(year: 2012, name: "#{year}º ano").first.students.map do |student|
    { code: SecureRandom.uuid, student_id: student.id,
      course_id: Course.where(year: 2013, name: "#{year + 1}º ano").first.id }
  end
end

Enrollment.insert_all(enrollments2013.flatten)

courses2013 = Course.where(year: 2013)

teacher_assignments2013 = courses2013.map do |course|
  subjects.map do |subject|
    { course_id: course.id, subject_id: subject.id, teacher_id: teachers.sample.id }
  end
end

TeacherAssignment.insert_all(teacher_assignments2013.flatten)

exams2013 = courses2013.map do |course|
  subjects.map do |subject|
    { course_id: course.id, subject_id: subject.id,
      realized_on: FFaker::Time.between(Date.new(2013, 1, 1), Date.new(2013, 12, 31)).to_s }
  end
end

Exam.insert_all(exams2013.flatten)

grades2013 = courses2013.map do |course|
  course.enrollments.map do |enrollment|
    course.exams.map do |exam|
      exams = []
      8.times do
        exams.push({ value: rand(0..10), enrollment_code: enrollment.code, exam_id: exam.id })
      end
      exams
    end
  end
end

Grade.insert_all(grades2013.flatten)
