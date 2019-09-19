class Option < ApplicationRecord
	belongs_to :poll

	has_many :poll_responses, dependent: :delete_all

	def was_responded_to_by?(student)
		self.poll_responses.where(student_id: student.id).count > 0
	end

	def get_response_by(student)
		self.poll_responses.where(student_id: student.id).first
	end
end
