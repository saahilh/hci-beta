class PollsController < ActionController::Base
	include AuthenticationHelper

	before_action :set_course, only: [:new, :show, :create, :end]
	before_action :set_lecturer, only: [:new]
	before_action :set_student, only: [:answer]
	before_action :authenticate_lecturer_for_course, only: [:new]

	def new
  	render "poll_class"
	end

	def create
		Poll.where(course: @course.id, active: true).all.each {|poll| poll.update_column(:active, false)}
		poll = Poll.create(question: params[:question], course: @course, active: true)

		params.each do |param, value|
			next unless param.starts_with?("opt")
			Option.create(number: param.gsub("opt", "").to_i, value: value, selected: 0, poll: poll)
		end

		CourseChannel.broadcast_to(
			@course, 
			poll: render_to_string('_student_poll', layout: false, locals: { poll: poll })
		)

		redirect_to course_poll_path(poll.course, poll)
	end

	def show
		poll = Poll.find(params[:id])

		if poll.active
			render "active_poll", locals: { poll: poll }
		else
			render 'lecturer_poll_results', locals: { poll: poll, data: poll.options.pluck(:value, :selected) }
		end
	end

	def end
		poll = Poll.find(params[:id])
		poll.update_column(:active, false)

		data = poll.options.pluck(:value, :selected)

		CourseChannel.broadcast_to(
			@course, 
			poll_end: true, 
			chart: render_to_string('student_poll_results', layout: false, locals: { data: data, question: poll.question }) 
		)

		render 'lecturer_poll_results', locals: { poll: poll, data: data }
	end

	def answer
		poll = Poll.find(id: params[:id])
		
		data = JSON.parse(@student.poll_data)

		changed = false

		if(data[poll.id.to_s])
			changed = true
			option = Option.find(data[poll.id.to_s])
			option.update_column(:selected, option.selected - 1)
		end

		option = ""

		params.each do |param|
			next unless param.starts_with?("opt")

			option = param.gsub("opt", "")
			break
		end

		CourseChannel.broadcast_to(
			poll.course, 
			answered: true, 
			changed: changed
		)

		option = Option.find(option)
		option.update_column(:selected, option.selected + 1)

		data[poll.id.to_s] = option.id
		@student.update_column(:poll_data, data.to_json)
	end
end
