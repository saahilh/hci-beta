class AddFlaggedToStudent < ActiveRecord::Migration[5.1]
  def change
  	add_column :students, :flagged, :text, default: ""
  end
end
