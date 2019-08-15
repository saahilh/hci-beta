class Course < ApplicationRecord
	has_many :questions, dependent: :delete_all
	has_many :polls, dependent: :delete_all
	belongs_to :lecturer
end
