class SetDefaultForAssociateConsultantGraduateBoolean < ActiveRecord::Migration
  def change
    change_column :associate_consultants, :graduated, :boolean, :default => false
    AssociateConsultant.find_each do |ac|
      if ac.graduated.blank?
        ac.graduated = false
        ac.save!
      end
    end
  end
end
