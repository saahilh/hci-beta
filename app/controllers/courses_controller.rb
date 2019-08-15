class CoursesController < ActionController::Base
	before_action :set_course, only: [:show, :ask_question, :professor_course_page, :delete, :poll]
	before_action :set_student, only: [:show, :ask_question]
	before_action :set_lecturer, only: [:professor_course_page, :delete]

	def set_course
		@course = Course.find(params[:id])
	end

	def set_student
		@student = Student.find_by(id: cookies[:student])

		if @student.nil? # set cookie
			@student = Student.create
			cookies[:student] = { value: cookies[:student], expires: 3.hours.from_now }
		end
	end

	def set_lecturer
		@lecturer = Lecturer.find_by(id: cookies[:logged_in])
	end

	def select_course
		course_name = params[:course_code].gsub(" ", "")
		@course = Course.find_by(name: course_name)

		if @course
			render json: { data: { redirect: "/courses/#{@course.id}" } }
		else
			render json: { data: { msg: "Course not found: #{course_name}" } }
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
				professor_question: render_to_string('_professor_question', layout:false, locals: {question: question}),
				question_id: question.id
			)
		end

		render json: { data: {} }
	end

	def professor_course_page
		if @lecturer
			if @lecturer.id.to_s == @course.lecturer.id.to_s
				render 'professor_course_page'
  		else
				render '/message', locals: { message: "Error: lecturer does not have access to course" }
			end
    else
      render '/message', locals: { message: "Error: not logged in" }
    end
	end

	def delete
		@course.delete
		redirect_to @lecturer
	end

	def poll
		render 'poll_class', locals:{ course: @course }
	end
end