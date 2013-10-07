module JuniorConsultantsHelper
  def alphabetically_sorted_user_names
    User.all.map { |user| [user.name, user.id]}.sort
  end

  def reviewing_group_list
    ReviewingGroup.all.map { |rg| [rg.name, rg.id] }
  end
end
