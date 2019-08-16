class AddDefaultToStudentPollData < ActiveRecord::Migration[5.1]
  def change
  	change_column :students, :poll_data, :text, default: "{}"
  end
end
