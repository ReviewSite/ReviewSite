class RemovePasswordColumnsFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :password_digest
    remove_column :users, :password_reset_token
    remove_column :users, :password_reset_sent_at
  end

  def down
    add_column :users, :password_digest, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
  end
end
