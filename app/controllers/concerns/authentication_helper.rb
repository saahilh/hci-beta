module AuthenticationHelper
	def set_course
		@course = Course.find(params[:id].gsub(" ", ""))
	end

	def set_student
		@student = Student.find_by(id: session[:student_id])

		if @student.nil?
			@student = Student.create
			session[:student_id] = @student.id
		end
	end

	def set_question
		@question = Question.find(params[:id])
	end

	def set_lecturer
		@lecturer = Lecturer.find_by(id: session[:lecturer_id])

		if @lecturer.nil?
			@message = "Error: not logged in"
			render '/message', locals: { message: "Error: not logged in" }
		end
	end

	def authenticate_lecturer_for_course
		if @lecturer
			if @lecturer.id.to_s != @course.lecturer.id.to_s
				render '/message', locals: { message: "Error: lecturer does not have access to course" }
			end
    else
      render '/message', locals: { message: "Error: not logged in" }
    end
	end
end