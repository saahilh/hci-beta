class AddTrackingToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :upvoted, :text
    add_column :students, :downvoted, :text
    add_column :students, :flagged, :text
  end
end
