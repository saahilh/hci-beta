class Question < ApplicationRecord
	belongs_to :course
	belongs_to :student
	has_many :votes, dependent: :delete_all
	has_many :flags, dependent: :delete_all

	FLAG_THRESHOLD = 5;
end
