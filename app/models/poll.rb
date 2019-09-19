class Poll < ApplicationRecord
	belongs_to :course
	has_many :options, dependent: :delete_all

	def get_vote_data
    vote_data = []

    self.options.each do |option|
      vote_data << [option.value, option.poll_responses.count]
    end

    vote_data
  end
end
