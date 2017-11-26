class AddQuestionsToStudent < ActiveRecord::Migration[5.1]
  def change
  	add_reference :students, :questions
  end
end
