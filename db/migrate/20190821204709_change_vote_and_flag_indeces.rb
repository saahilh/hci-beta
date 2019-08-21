class ChangeVoteAndFlagIndeces < ActiveRecord::Migration[5.1]
  def change
  	remove_index :flags, column: [:course_id, :question_id, :student_id]
  	remove_index :votes, column: [:course_id, :question_id, :student_id]
  end
end
