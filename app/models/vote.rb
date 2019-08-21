class Vote < ApplicationRecord
  belongs_to :course
  belongs_to :question
  belongs_to :student

  def is_upvote?
  	self.is_upvote
  end

  def is_downvote?
  	!self.is_upvote
  end
end
