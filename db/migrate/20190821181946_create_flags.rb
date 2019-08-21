class CreateFlags < ActiveRecord::Migration[5.1]
  def change
    create_table :flags do |t|
      t.references :course, foreign_key: true
      t.references :question, foreign_key: true
      t.references :student, foreign_key: true
      t.index [:course_id, :question_id, :student_id], unique: true

      t.timestamps
    end
  end
end
