module ReviewingGroupMembersHelper
  def reviewing_group_list
    ReviewingGroup.all.map { |rg| [rg.name, rg.id] }
  end

  def users_list
    User.all.map { |user| [user.name, user.id] } 
  end
end
