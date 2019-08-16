module AuthenticationHelper
	def set_course
		@course = Course.find(params[:id].gsub(" ", ""))
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