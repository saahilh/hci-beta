class QuestionsController < ActionController::Base
	include AuthenticationHelper

	before_action :set_student, except: [:delete, :in_class, :after_class]
	before_action :set_question

	def delete
		course = Course.find(@question.course.id)
		@question.delete
		
		CourseChannel.broadcast_to(
			course, 
			delete_question: params[:id]
		)
	end

	def in_class
		new_status = "answered in class"
		new_status = "pending" if(@question.status==new_status)
		is_pending = new_status=="pending"

		@question.update_column(:status, new_status)
		
		CourseChannel.broadcast_to(
			Course.find(@question.course.id),
			question_id: @question.id,
			in_class_enabled: !is_pending, 
			pending: is_pending
		)
	end

	def after_class
		new_status = "will answer after class"
		new_status = "pending" if(@question.status==new_status)
		is_pending = new_status=="pending"

		@question.update_column(:status, new_status)
		
		CourseChannel.broadcast_to(
			Course.find(@question.course.id),
			question_id: @question.id,
			after_class_enabled: !is_pending, 
			pending: is_pending
		)
	end

	def thumbsup
		data = JSON.parse(@student.question_data)

		if(data[@question.id.to_s]=="up")
			@question.update_column(:upvotes, @question.upvotes - 1)
			data[@question.id.to_s] = ""
		else
			@question.update_column(:downvotes, @question.downvotes - 1) if(data[@question.id.to_s]=="down")
			@question.update_column(:upvotes, @question.upvotes + 1)
			data[@question.id.to_s] = "up"
		end

		@student.update_column(:question_data, data.to_json)
		
		
		CourseChannel.broadcast_to(
			Course.find(@question.course.id), 
			vote: @question.id,
			upvote_count: @question.upvotes,
			downvote_count: @question.downvotes
		)
	end

	def thumbsdown
		data = JSON.parse(@student.question_data)

		if(data[@question.id.to_s]=="down")
			@question.update_column(:downvotes, @question.downvotes - 1)
			data[@question.id.to_s] = ""
		else
			@question.update_column(:upvotes, @question.upvotes - 1) if(data[@question.id.to_s]=="up")
			@question.update_column(:downvotes, @question.downvotes + 1)
			data[@question.id.to_s] = "down"
		end

		@student.update_column(:question_data, data.to_json)
		
		CourseChannel.broadcast_to(
			Course.find(@question.course.id), 
			vote: @question.id,
			upvote_count: @question.upvotes,
			downvote_count: @question.downvotes
		)
	end

	def flag
		@question.update_column(:flagged, @question.flagged + 1)
		flagged = JSON.parse(@student.flagged)

		if(!flagged[@question.id.to_s])
			flagged[@question.id.to_s] = true

			@student.update_column(:flagged, flagged.to_json)

			if(@question.flagged >= Question::FLAG_THRESHOLD)
				CourseChannel.broadcast_to(
					Course.find(@question.course.id), 
					flag_thresh_alert: @question.id
				)
			end
		end
	end
end
