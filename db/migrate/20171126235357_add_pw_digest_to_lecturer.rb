class AddPwDigestToLecturer < ActiveRecord::Migration[5.1]
  def change
    add_column :lecturers, :password_digest, :string
  end
end
