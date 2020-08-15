class Question < ApplicationRecord
	belongs_to :course
	belongs_to :student
	has_many :votes, dependent: :delete_all
	has_many :flags, dependent: :delete_all
	validates :question, presence: true

	FLAG_THRESHOLD = 5.freeze
	ANSWER_IN_CLASS_STATUS_MESSAGE = "answered in class".freeze
	PENDING_STATUS_MESSAGE = "pending".freeze
	ANSWER_AFTER_CLASS_STATUS_MESSAGE = "will answer after class".freeze

	def upvote_count
		Vote.where(course: self.course, question: self, is_upvote: true).count
	end

	def downvote_count
		Vote.where(course: self.course, question: self, is_upvote: false).count
	end

	def toggle_answer_in_class
		self.toggle_status_using(ANSWER_IN_CLASS_STATUS_MESSAGE)
	end

	def toggle_answer_after_class
		self.toggle_status_using(ANSWER_AFTER_CLASS_STATUS_MESSAGE)
	end

	# returns true if the new status is equal to the argument
	# otherwise the new status is pending, so returns false
	def toggle_status_using(new_status)
		if self.status==new_status
			new_status = PENDING_STATUS_MESSAGE
		end

		self.update_column(:status, new_status)

		new_status
	end

	def broadcast_vote_data
		CourseChannel.broadcast_to(
			Course.find(self.course.id), 
			question_id: self.id,
			action: "vote",
			upvote_count: self.upvote_count,
			downvote_count: self.downvote_count
		)
	end

	def broadcast_status(new_status)
		CourseChannel.broadcast_to(
			Course.find(self.course.id),
			question_id: self.id,
			action: "new_status",
			new_status: new_status
		)
	end

	def has_passed_flag_threshold?
		Flag.where(course: self.course, question: self).count >= FLAG_THRESHOLD
	end

	def answer_in_class?
		self.status == ANSWER_IN_CLASS_STATUS_MESSAGE
	end

	def answer_after_class?
		self.status == ANSWER_AFTER_CLASS_STATUS_MESSAGE
	end
end
