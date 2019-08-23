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
		Poll.where(course: self.id, active: true).count > 0
	end

	def get_active_poll
		Poll.where(course: self.id, active: true).last
	end
end
