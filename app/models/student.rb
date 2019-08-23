class Student < ApplicationRecord
	has_many :flags
	has_many :votes
	has_many :questions

	def has_flagged?(question)
		Flag.where(course: question.course, question: question, student: self).count==1
	end

	def has_voted_for?(question)
		vote = Vote.where(course: question.course, question: question, student: self)
		!vote.empty?
	end

	def has_upvoted?(question)
		self.has_voted_for?(question) && self.get_vote_for(question).is_upvote?
	end

	def has_downvoted?(question)
		self.has_voted_for?(question) && self.get_vote_for(question).is_downvote?
	end

	def get_vote_for(question)
		vote = Vote.where(course: question.course, question: question, student: self)

		if vote.empty?
			nil
		else
			vote.first
		end
	end

	def toggle_downvote_for(question)
		if self.has_voted_for?(question)
			vote = self.get_vote_for(question)

			if(vote.is_upvote?)
				vote.update_column(:is_upvote, false)
			else
				vote.delete
			end
		else
			vote = Vote.create(course: question.course, question: question, student: self, is_upvote: false)
		end

		vote
	end

	def toggle_upvote_for(question)
		if self.has_voted_for?(question)
			vote = self.get_vote_for(question)

			if(vote.is_downvote?)
				vote.update_column(:is_upvote, true)
			else
				vote.delete
			end
		else
			vote = Vote.create(course: question.course, question: question, student: self, is_upvote: true)
		end

		vote
	end
end
