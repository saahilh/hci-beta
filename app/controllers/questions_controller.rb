class QuestionsController < ActionController::Base
	before_action :set_cookie

	def set_cookie
		if cookies[:student].blank? 
			student = Student.create
			cookies[:student] = { value: student.id, expires: 3.hours.from_now }
		end
	end

	def delete
		question = Question.find(params[:id])
		course = Course.find(question.course.id)
		question.delete
		
		CourseChannel.broadcast_to(
			course, 
			delete_question: params[:id]
		)
	end

	def in_class
		question = Question.find(params[:id])

		new_status = "answered in class"
		new_status = "pending" if(question.status==new_status)
		is_pending = new_status=="pending"

		question.update_column(:status, new_status)
		
		CourseChannel.broadcast_to(
			Course.find(question.course.id),
			question_id: question.id,
			in_class_enabled: !is_pending, 
			pending: is_pending
		)
	end

	def after_class
		question = Question.find(params[:id])
		
		new_status = "will answer after class"
		new_status = "pending" if(question.status==new_status)
		is_pending = new_status=="pending"

		question.update_column(:status, new_status)
		
		CourseChannel.broadcast_to(
			Course.find(question.course.id),
			question_id: question.id,
			after_class_enabled: !is_pending, 
			pending: is_pending
		)
	end

	def thumbsup
		student = Student.find(cookies[:student])
		question = Question.find(params[:id])

		data = student.question_data.blank? ? {} : JSON.parse(student.question_data)

		if(data["#{question.id}"]=="up")
			question.update_column(:upvotes, question.upvotes - 1)
			data["#{question.id}"] = ""
		else
			question.update_column(:downvotes, question.downvotes - 1) if(data["#{question.id}"]=="down")
			question.update_column(:upvotes, question.upvotes + 1)
			data["#{question.id}"] = "up"
		end

		student.update_column(:question_data, data.to_json)
		
		
		CourseChannel.broadcast_to(
			Course.find(question.course.id), 
			vote: question.id,
			upvote_count: question.upvotes,
			downvote_count: question.downvotes
		)
	end

	def thumbsdown
		student = Student.find(cookies[:student])
		question = Question.find(params[:id])

		data = student.question_data.blank? ? {} : JSON.parse(student.question_data)

		if(data["#{question.id}"]=="down")
			question.update_column(:downvotes, question.downvotes - 1)
			data["#{question.id}"] = ""
		else
			question.update_column(:upvotes, question.upvotes - 1) if(data["#{question.id}"]=="up")
			question.update_column(:downvotes, question.downvotes + 1)
			data["#{question.id}"] = "down"
		end

		student.update_column(:question_data, data.to_json)
		
		CourseChannel.broadcast_to(
			Course.find(question.course.id), 
			vote: question.id,
			upvote_count: question.upvotes,
			downvote_count: question.downvotes
		)
	end

	def flag
		question = Question.find(params[:id])
		question.update_column(:flagged, question.flagged + 1)

		student = Student.find(cookies[:student])
		flagged = student.flagged.blank? ? {} : JSON.parse(student.flagged)

		if(!flagged["#{question.id}"])
			flagged["#{question.id}"] = true

			student.update_column(:flagged, flagged.to_json)

			if(question.flagged >= Question::FLAG_THRESHOLD)
				CourseChannel.broadcast_to(
					Course.find(question.course.id), 
					flag_thresh_alert: question.id
				)
			end
		end
	end
end
