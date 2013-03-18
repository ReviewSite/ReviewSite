class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.references :review

      t.timestamps
    end
    add_index :invitations, :review_id
  end
end
