class CreateReviewingGroups < ActiveRecord::Migration
  def change
    create_table :reviewing_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
