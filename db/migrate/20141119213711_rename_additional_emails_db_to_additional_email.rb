class RenameAdditionalEmailsDbToAdditionalEmail < ActiveRecord::Migration
  def up
    rename_table :additional_emails, :additional_email
  end

  def down
    rename_table :additional_email, :additional_emails
  end
end
