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

  def was_responded_to_by?(student)
    self.options.map { |option| option.was_responded_to_by?(student) }.include? true
  end

  def get_response_by(student)
    self.options.map { |option| option.get_response_by(student) }.find { |option| !option.nil? }
  end

  def deactivate
    self.update_column(:active, false)
  end
end
