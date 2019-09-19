class Course < ApplicationRecord
	has_many :questions, dependent: :delete_all
	has_many :polls, dependent: :delete_all
	has_many :flags, dependent: :delete_all
	has_many :votes, dependent: :delete_all

	belongs_to :lecturer

	validates :name, presence: true
	validates :name, format: { with: /\A[A-z]{4}[0-9]{3}\z/, message: "for course must be 4 letters followed by 3 numbers" }
	validates :name, uniqueness: { message: "for course already taken" }

	def has_active_poll?
		self.polls.where(active: true).count > 0
	end

	def get_active_poll
		self.polls.where(active: true).last
	end

	def deactivate_all_polls
		self.polls.where(active: true).each {|poll| poll.update_column(:active, false)}
	end
end
