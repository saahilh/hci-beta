class Vote < ApplicationRecord
  belongs_to :course
  belongs_to :question
  belongs_to :student
end
