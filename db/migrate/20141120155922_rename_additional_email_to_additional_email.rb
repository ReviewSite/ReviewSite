class RenameAdditionalEmailToAdditionalEmail < ActiveRecord::Migration
  def up
    rename_table :additional_email, :additional_emails
  end

  def down
    rename_table :additional_emails, :additional_email
  end
end
