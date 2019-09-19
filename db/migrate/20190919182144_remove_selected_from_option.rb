class RemoveSelectedFromOption < ActiveRecord::Migration[5.1]
  def change
  	remove_column :options, :selected
  end
end
