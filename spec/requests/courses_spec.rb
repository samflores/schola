# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/courses' do
  let(:valid_attributes) do
    attributes_for(:course)
  end

  let(:invalid_attributes) do
    attributes_for(:course, name: '')
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Course.create! valid_attributes
      get courses_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      course = Course.create! valid_attributes
      get course_url(course)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_course_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      course = Course.create! valid_attributes
      get edit_course_url(course)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Course' do
        expect do
          post courses_url, params: { course: valid_attributes }
        end.to change(Course, :count).by(1)
      end

      it 'redirects to the created course' do
        post courses_url, params: { course: valid_attributes }
        expect(response).to redirect_to(course_url(Course.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Course' do
        expect do
          post courses_url, params: { course: invalid_attributes }
        end.not_to change(Course, :count)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post courses_url, params: { course: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: '1st grade' }
      end

      it 'updates the requested course' do
        course = Course.create! valid_attributes
        patch course_url(course), params: { course: new_attributes }
        course.reload
        expect(course.name).to eq('1st grade')
      end

      it 'redirects to the course' do
        course = Course.create! valid_attributes
        patch course_url(course), params: { course: new_attributes }
        course.reload
        expect(response).to redirect_to(course_url(course))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        course = Course.create! valid_attributes
        patch course_url(course), params: { course: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested course' do
      course = Course.create! valid_attributes
      expect do
        delete course_url(course)
      end.to change(Course, :count).by(-1)
    end

    it 'redirects to the courses list' do
      course = Course.create! valid_attributes
      delete course_url(course)
      expect(response).to redirect_to(courses_url)
    end
  end
end
