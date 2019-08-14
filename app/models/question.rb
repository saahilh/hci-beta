class Question < ApplicationRecord
	belongs_to :course
	belongs_to :student

	FLAG_THRESHOLD = 5;

end
