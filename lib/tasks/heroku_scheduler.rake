task :check_and_graduate_acs => :environment do
  graduates = AssociateConsultant.select(&:can_graduate?)
  graduates.each do |graduate|
    graduate.update_attribute(:graduated, true)
  end
end