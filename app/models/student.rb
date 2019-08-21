class Student < ApplicationRecord
	has_many :flags
	has_many :questions

	def get_flagged_questions
		return JSON.parse(self.flagged)
	end

	def get_question_data
		return JSON.parse(self.question_data)
	end
end
