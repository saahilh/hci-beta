class AddPollDataToStudent < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :poll_data, :text, default: ''
  end
end
