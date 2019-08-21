class Lecturer < ApplicationRecord
	has_many :courses
	has_secure_password

	validates :name, presence: true
	validates :email, presence: true
	validates :email, uniqueness: { message: "already in use" }
	validates :password, presence: true

	def is_lecturer_for(course)
		course.lecturer.id==self.id
	end
end
