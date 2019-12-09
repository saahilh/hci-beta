class PollsController < ActionController::Base
	include AuthenticationHelper
	layout "general"

	before_action :set_course, only: [:new, :show, :create, :end]
	before_action :set_lecturer, only: [:new]
	before_action :set_student, only: [:answer]
	before_action :set_poll, only: [:show, :end, :answer]
	before_action :authenticate_lecturer_for_course, only: [:new]

	def new
  		render "poll_class"
	end

	def create
		Poll.where(course: @course.id, active: true).all.each { |poll| poll.update_column(:active, false) }
		poll = Poll.create(question: params[:question], course: @course, active: true)

		params[:options].each do |number, value|
			Option.create(number: number.to_i, value: value, poll: poll)
		end

		CourseChannel.broadcast_to(
			@course, 
			action: 'new_poll',
			poll: render_to_string('_student_poll', layout: false, locals: { poll: poll, student: nil })
		)

		redirect_to course_poll_path(poll.course, poll)
	end

	def show
		render 'poll', locals: { poll: @poll, course: @poll.course }
	end

	def end
		@poll.update_column(:active, false)

		CourseChannel.broadcast_to(
			@course, 
			poll_end: true, 
			chart: render_to_string('student_poll_results', layout: false, locals: { poll: @poll }) 
		)

		render 'poll', locals: { poll: @poll, course: @poll.course }
	end

	def answer
		option = Option.find(params[:option_id])
		changed = @poll.was_responded_to_by?(@student)

		if changed
			@poll.get_response_by(@student).delete
		end

		PollResponse.create(student_id: @student.id, option_id: option.id)

		CourseChannel.broadcast_to(
			@poll.course,
			action: 'poll_response',
			answered: true, 
			changed: changed
		)
	end
end
