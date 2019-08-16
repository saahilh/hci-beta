class AddDefaultToStudentFlaggedAndQuestionData < ActiveRecord::Migration[5.1]
  def change
  	change_column :students, :flagged, :text, default: "{}"
  	change_column :students, :question_data, :text, default: "{}"
  end
end
