class CoursesController < ActionController::Base
	include AuthenticationHelper

	before_action :set_course, only: [:show, :ask_question, :lecturer_course_page, :destroy, :poll]
	before_action :set_student, only: [:show, :ask_question]
	before_action :set_lecturer, only: [:lecturer_course_page, :destroy]
	before_action :authenticate_lecturer_for_course, only: [:lecturer_course_page]

	def select_course
		@course = Course.find_by(name: params[:course_code].gsub(" ", ""))

		if @course
			render json: { data: { redirect: "/courses/#{@course.id}" } }
		else
			render json: { data: { msg: "Course not found: #{params[:course_code]}" } }
		end
	end

	def show
		render 'student_course_page', locals: { flagged: JSON.parse(@student.flagged), data: JSON.parse(@student.question_data) }
	end

	def create
		new_course_name = params[:new_course].upcase.gsub(" ", "")
		success = 0

		if(new_course_name.blank?)
			msg = "No name entered"
		elsif(Course.where(name: new_course_name).count != 0)
			msg = "Course already exists"
		elsif(new_course_name.length > 7)
			msg = "Course code too long"
		elsif !/[A-z]{4}[0-9]{3}/.match(new_course_name)
			msg = "Invalid course code"
		else
			course = Course.create(name: new_course_name, lecturer: Lecturer.find(params[:lecturer_id]))
			success = course.id
			msg = "Successfully created course #{course.name}"
		end

		render json: { data: { msg: msg, success: success }}
	end

	def ask_question
		if(!params[:question].blank?)
			question = Question.create(question: params[:question], course: @course, student: @student)

			CourseChannel.broadcast_to(
				@course,
				question: true,
				student_question: render_to_string('_student_question', layout:false, locals: {question: question, vote: ""}),
				lecturer_question: render_to_string('_lecturer_question', layout:false, locals: {question: question}),
				question_id: question.id
			)
		end

		render json: { data: {} }
	end

	def lecturer_course_page
		render 'lecturer_course_page'
	end

	def destroy
		@course.delete
		redirect_to @lecturer
	end

	def poll
		render 'poll_class'
	end
end