class RemovePollDataFromStudent < ActiveRecord::Migration[5.1]
  def change
  	remove_column :students, :poll_data
  end
end
