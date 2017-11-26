class AddDefaultsToVariousColumns < ActiveRecord::Migration[5.1]
  def change
  	change_column :students, :upvoted, :text, default: ""
    change_column :students, :downvoted, :text, default: ""
    change_column :students, :flagged, :text, default: ""
    change_column :questions, :status, :string, default: "Pending"
    change_column :questions, :upvotes, :integer, default: 0
    change_column :questions, :downvotes, :integer, default: 0
  end
end
