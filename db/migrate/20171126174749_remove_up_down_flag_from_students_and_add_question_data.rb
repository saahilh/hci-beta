class RemoveUpDownFlagFromStudentsAndAddQuestionData < ActiveRecord::Migration[5.1]
  def change
  	remove_column :students, :upvoted
    remove_column :students, :downvoted
    remove_column :students, :flagged
    add_column :students, :question_data, :text, default: ""
  end
end
