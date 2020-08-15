module AuthenticationHelper
	def set_course
		id = params[:course_id]
		id ||= params[:id]
		@course = Course.find(id)
	end

	def set_student
		@student = Student.find_by(id: session[:student_id])

		return unless @student.nil?

		@student = Student.create
		session[:student_id] = @student.id
	end

	def set_question
		@question = Question.find(params[:id])
	end

	def set_poll
		@poll = Poll.find(params[:id])
	end

	def set_lecturer
		@lecturer = Lecturer.find_by(id: session[:lecturer_id])

		return unless @lecturer.nil?

		render '/application/message', locals: { message: "Error: not logged in" }
	end

	def authenticate_lecturer_for_course
		if @lecturer
			return if @lecturer.is_lecturer_for?(@course) # success
			
			message = "Error: lecturer does not have access to course"
		else
			message =  "Error: not logged in"
		end

		render '/application/message', locals: { message: message }
	end
end
