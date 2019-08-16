class Lecturer < ApplicationRecord
	has_many :courses
	has_secure_password

	validates :name, presence: true
	validates :email, presence: true
	validates :email, uniqueness: { message: "already in use" }
	validates :password, presence: true
end
