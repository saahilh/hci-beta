class Lecturer < ApplicationRecord
	has_many :courses
	has_secure_password
end
