class ChangeStudentFlaggedDefaultAgain < ActiveRecord::Migration[5.1]
  def change
  	change_column :students, :flagged, :text, default: "{}"
  end
end
