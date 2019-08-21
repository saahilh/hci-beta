class Course < ApplicationRecord
	has_many :questions, dependent: :delete_all
	has_many :polls, dependent: :delete_all
	has_many :flags, dependent: :delete_all
	belongs_to :lecturer

	validates :name, presence: true
	validates :name, format: { with: /\A[A-z]{4}[0-9]{3}\z/, message: "for course must be 4 letters followed by 3 numbers" }
	validates :name, uniqueness: { message: "for course already taken" }


	def generate_index_buttons_html
		html = "<a class=\"btn btn-default big-btn fit course-button\" data-method=\"get\" href=\"/courses/#{self.id}/course_page\">#{self.name}</a>"
		html += "<a class=\"btn btn-danger big-btn delete-button fa fa-arrow-left\" data-method=\"delete\" rel=\"no-follow\" href=\"/courses/#{self.id}\">Delete</a>"
	end
end
