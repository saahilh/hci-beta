class AddPwConfirmationToLecturerForEncrpytion < ActiveRecord::Migration[5.1]
  def change
    add_column :lecturers, :password_confirmation, :string
  end
end
