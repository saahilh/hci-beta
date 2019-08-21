class CoursesController < ActionController::Base
	include AuthenticationHelper

	before_action :set_course, except: [:select_course, :create]
	before_action :set_student, only: [:show, :ask_question]
	before_action :set_lecturer, only: [:create, :ask_question, :lecturer_course_page, :destroy]
	before_action :authenticate_lecturer_for_course, only: [:lecturer_course_page, :destroy]

	def select_course
		@course = Course.find_by(name: params[:course_code].gsub(" ", ""))

		if @course
			render json: { data: { redirect: "/courses/#{@course.id}" }}
		else
			render json: { data: { msg: "Course not found: #{params[:course_code]}" }}
		end
	end

	def show
		render 'course_page', locals: { flagged: @student.get_flagged_questions, data: @student.get_question_data }
	end

	def create
		course = Course.create(name: params[:new_course].upcase.gsub(" ", ""), lecturer: @lecturer)
		render json: { data: { course_id: course.id, course_name: course.name, errors: course.errors.full_messages }}
	end

	def ask_question
		if(!params[:question].blank?)
			question = Question.create(question: params[:question], course: @course, student: @student)

			CourseChannel.broadcast_to(
				@course,
				question: true,
				student_question: render_to_string('_question', layout: false, locals: {question: question, vote: ""}),
				lecturer_question: render_to_string('_question', layout: false, locals: {question: question}),
				question_id: question.id
			)
		end

		render json: { data: {} }
	end

	def lecturer_course_page
		render 'course_page', locals: { flagged: {}, data: {}}
	end

	def destroy
		@course.delete
		redirect_to @lecturer
	end

	def poll
		render 'poll_class'
	end
end