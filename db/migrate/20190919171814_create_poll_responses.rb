class CreatePollResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :poll_responses do |t|
      t.references :student, foreign_key: true
      t.references :option, foreign_key: true

      t.timestamps
    end
  end
end
