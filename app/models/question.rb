class Question < ApplicationRecord
	belongs_to :course
	belongs_to :student
	has_many :flags

	FLAG_THRESHOLD = 5;
end
