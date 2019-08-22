class CoursesController < ActionController::Base
	include AuthenticationHelper

	before_action :set_course, except: [:select_course, :create]
	before_action :set_student, only: [:show, :ask_question]
	before_action :set_lecturer, only: [:create, :ask_question, :destroy]
	before_action :authenticate_lecturer_for_course, only: [:destroy]

	def create
		course = Course.create(name: params[:new_course].upcase.gsub(" ", ""), lecturer: @lecturer)

		render json: { data: { course_id: course.id, course_name: course.name, errors: course.errors.full_messages }}
	end

	def show
		@lecturer = Lecturer.find_by(id: session[:lecturer_id])

		render 'course_page', locals: { course: @course, lecturer: @lecturer, student: @student }
	end

	def destroy
		@course.delete

		redirect_to @lecturer
	end

	def select_course
		@course = Course.find_by(name: params[:course_code].gsub(" ", ""))

		if @course
			render json: { data: { redirect: "/courses/#{@course.id}" }}
		else
			render json: { data: { msg: "Course not found: #{params[:course_code]}" }}
		end
	end
end
