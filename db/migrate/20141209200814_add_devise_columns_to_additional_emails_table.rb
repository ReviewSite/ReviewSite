class AddDeviseColumnsToAdditionalEmailsTable < ActiveRecord::Migration
  def change
    add_column :additional_emails, :confirmation_token, :string
    add_column :additional_emails, :confirmed_at, :datetime
    add_column :additional_emails, :confirmation_sent_at, :datetime
  end
end
