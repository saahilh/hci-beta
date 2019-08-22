class QuestionsController < ActionController::Base
	include AuthenticationHelper

	before_action :set_student, only: [:create, :upvote, :downvote, :flag]
	before_action :set_course, only: [:create]
	before_action :set_question, except: [:create]

	def create
		@question = Question.create(question: params[:question], course: @course, student: @student)

		if @question.errors.full_messages.empty?
			CourseChannel.broadcast_to(
				@course,
				question_id: @question.id,
				action: "new_question",
				student_question: render_to_string('courses/_question', layout: false, locals: {question: @question, lecturer: nil, student: nil, course: @course}),
				lecturer_question: render_to_string('courses/_question', layout: false, locals: {question: @question, lecturer: @course.lecturer, student: nil, course: @course})
			)
		end

		render json: { data: { errors: @question.errors.full_messages }}
	end

	def destroy
		course = Course.find(@question.course.id)
		@question.destroy
		
		CourseChannel.broadcast_to(
			course,
			question_id: params[:id],
			action: "delete_question"
		)
	end

	def in_class
		new_status = @question.toggle_answer_in_class
		@question.broadcast_status(new_status)
	end

	def after_class
		new_status = @question.toggle_answer_after_class
		@question.broadcast_status(new_status)
	end

	def upvote
		@student.toggle_upvote_for(@question)
		@question.broadcast_vote_data
	end

	def downvote
		@student.toggle_downvote_for(@question)
		@question.broadcast_vote_data
	end

	def flag
		flag = Flag.create(course: @question.course, question: @question, student: @student)

		if(Flag.where(course: @question.course, question: @question).count >= Question::FLAG_THRESHOLD)
			CourseChannel.broadcast_to(
				Course.find(@question.course.id),
				question_id: @question.id,
				action: "flag_threshold_exceeded"
			)
		end

		render json: { data: { errors: flag.errors.full_messages }}
	end
end
