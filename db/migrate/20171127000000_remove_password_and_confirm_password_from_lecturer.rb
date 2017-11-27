class RemovePasswordAndConfirmPasswordFromLecturer < ActiveRecord::Migration[5.1]
  def change
  	remove_column :lecturers, :password
  	remove_column :lecturers, :password_confirmation
  end
end
