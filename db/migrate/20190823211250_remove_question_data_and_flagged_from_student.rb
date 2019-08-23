class RemoveQuestionDataAndFlaggedFromStudent < ActiveRecord::Migration[5.1]
  def change
  	remove_column :students, :flagged
  	remove_column :students, :question_data
  end
end
