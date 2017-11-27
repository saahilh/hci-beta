class CoursesController < ActionController::Base
	def set_cookie
		if cookies[:student].blank? 
			student = Student.create
			cookies[:student] = { value: student.id, expires: 3.hours.from_now }
		end
	end

	def select_course
		course = params[:course_code]
		course = course.insert(4, " ") if course.length == 7

		if(Course.where(name: course.upcase).count>0)
			render json: { data: { redirect: "/courses/#{ Course.where(name: course.upcase).first.id }" } }
		else
			render json: { data: { msg: "Course not found: #{course}" } }
		end
	end

	def show
		set_cookie
		flagged = Student.find(cookies[:student]).flagged
		flagged = flagged.blank? ? {} : JSON.parse(flagged)
		data = Student.find(cookies[:student]).question_data
		data = data.blank? ? {} : JSON.parse(data)
		render 'ask_question', locals: { course: Course.find(params[:id]), flagged: flagged, data: data }
	end

	def create
		new_course = params[:new_course].upcase
		new_course = new_course.insert(4, " ") if new_course.length == 7
		success = 0

		if(new_course.blank?)
			msg = "No name entered"
		elsif(Course.where(name: new_course).count != 0)
			msg = "Course already exists"
		elsif(new_course.gsub(" ", "").length > 7)
			msg = "Course code too long"
		elsif !/[A-z]{4} [0-9]{3}/.match(new_course)
			msg = "Invalid course code"
		else
			course = Course.create(name: new_course, lecturer: Lecturer.find(params[:lecturer_id]))
			success = course.id
			msg = "Successfully created course #{course.name}"
		end

		render json: { data: { msg: msg, success: success }}
	end

	def ask_question
		set_cookie

		course = Course.find(params[:id])
		if(!params[:question].blank?)
			question = Question.create(question: params[:question], course_id: course.id, student: Student.find(cookies[:student]))
			CourseChannel.broadcast_to(
				course, 
				question: render_to_string('_student_questions', layout:false, locals: {question: question, vote: ""}),
				prof_question: render_to_string('_prof_questions', layout:false, locals: {question: question}),
				question_id: question.id
			)
		end
		render json: {data: {}}
	end

	def course_page
		course = Course.find(params[:id])
	    if(cookies[:logged_in].to_s==course.lecturer.id.to_s)
	  	  render 'course_page', locals: {course: course }
	    else
	      render '/message', locals: { message: "Error: not logged in" }
	    end
	end

	def delete
		course = Course.find(params[:id])
		lecturer = course.lecturer.id
		Question.where(course_id: course.id).delete_all
		course.delete
		redirect_to "/lecturers/#{lecturer}/"
	end

	def poll
		render 'poll_class', locals:{ course: Course.find(params[:id]) }
	end

end