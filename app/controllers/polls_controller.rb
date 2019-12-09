class PollsController < ActionController::Base
	include AuthenticationHelper
	layout "general"

	before_action :set_course, only: [:new, :show, :create, :end]
	before_action :set_lecturer, only: [:new]
	before_action :set_student, only: [:answer]
	before_action :set_poll, only: [:show, :end, :answer]
	before_action :authenticate_lecturer_for_course, only: [:new]

	def new
	end

	def create
		@course.deactivate_all_polls # in case poll wasn't properly closed

		poll = Poll.create(question: params[:question], course: @course, active: true)
		poll.add_options(params[:options])

		CourseChannel.broadcast_to(
			@course, 
			action: 'new_poll',
			poll: render_to_string('_student_poll', layout: false, locals: { poll: poll, student: nil })
		)

		redirect_to course_poll_path(poll.course, poll)
	end

	def show
		render 'poll', locals: { poll: @poll, course: @course }
	end

	def end
		@poll.deactivate

		CourseChannel.broadcast_to(
			@course, 
			poll_end: true, 
			chart: render_to_string(partial: 'student_poll_results', layout: false, locals: { poll: @poll }) 
		)

		render 'poll', locals: { poll: @poll, course: @course }
	end

	def answer
		option = Option.find(params[:option_id])
		changed = @poll.was_responded_to_by?(@student)

		@poll.get_response_by(@student).delete if changed

		PollResponse.create(student_id: @student.id, option_id: option.id)

		CourseChannel.broadcast_to(
			@poll.course,
			action: 'poll_response',
			answered: true, 
			changed: changed
		)
	end
end
