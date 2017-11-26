class FixTextInQuestionStatusDefault < ActiveRecord::Migration[5.1]
  def change
  	change_column :questions, :status, :string, default: "pending"
  end
end
