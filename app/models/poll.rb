class Poll < ApplicationRecord
	belongs_to :course
	has_many :options, dependent: delete_all
end
