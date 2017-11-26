class PollsController < ActionController::Base
	def new
		course = Course.find(params[:id])
		if(cookies[:logged_in].to_s==course.lecturer.id.to_s)
	  	  render "poll_class", locals:{ course: course }
	    else
	      render '/message', locals: { message: "Error: not logged in" }
	    end
	end

	def create
		course = Course.find(params[:id])
		poll = Poll.create(question: params[:question], course: course, active: true)

		params.each do |param, value|
			if param.starts_with?("opt")
				Option.create(number: param.gsub("opt", "").to_i, value: value, selected: 0, poll: poll)
			end
		end

		CourseChannel.broadcast_to(course, poll: render_to_string('student_poll', layout: false, locals:{poll: poll}))

		render "active_poll", locals: { course: course, poll: poll }
	end

	def end
		course = Course.find(params[:id])
		poll = Poll.find(params[:poll_id])
		poll.update_column(:active, false)

		data = poll.options.pluck(:value, :selected)

		CourseChannel.broadcast_to(course, { poll_end: true, chart: render_to_string('student_poll_results', layout: false, locals: { data: data, question: poll.question }) } )

		render 'professor_poll_results', locals: { poll: poll, data: data }
	end

	def answer
		poll = Poll.where(course_id: params[:id], active: true).first
		
		student = Student.find(cookies[:student])
		data = student.poll_data
		data = data.blank? ? {} : JSON.parse(data)
		changed = false

		if(data["#{poll.id}"])
			changed = true
			option = Option.find(data["#{poll.id}"])
			option.update_column(:selected, option.selected - 1)
		end

		option = ""

		params.each do |param|
			if param.starts_with?("opt")
				option = param.gsub("opt", "")
				break
			end
		end

		CourseChannel.broadcast_to(poll.course, answered: true, changed: changed)

		option = Option.find(option)
		option.update_column(:selected, option.selected + 1)

		data["#{poll.id}"] = option.id
		student.update_column(:poll_data, data.to_json)
	end
end
