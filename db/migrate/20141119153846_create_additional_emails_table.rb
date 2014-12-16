class CreateAdditionalEmailsTable < ActiveRecord::Migration
  def up
    create_table :additional_emails do |t|
      t.string :email
      t.integer :user_id
    end
  end

  def down
    drop_table :additional_email
  end
end
