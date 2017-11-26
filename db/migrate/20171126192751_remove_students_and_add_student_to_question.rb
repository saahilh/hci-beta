class RemoveStudentsAndAddStudentToQuestion < ActiveRecord::Migration[5.1]
  def change
  	remove_reference :students, :questions
  	add_reference :questions, :student
  end
end
