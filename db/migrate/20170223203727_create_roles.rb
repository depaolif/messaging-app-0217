class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :role_type
      t.integer :user_id
      t.integer :group_id
    end
  end
end
