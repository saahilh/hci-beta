class AddFlagCountToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :flagged, :integer, default: 0
  end
end
