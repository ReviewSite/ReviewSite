module ApplicationHelper
  def full_title(page_title)
    base_title = "Review Website"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def alphabetically_sorted_reviewing_groups
    ReviewingGroup.all.map { |rg| [rg.name, rg.id] }.sort
  end

  def users_list
    User.all.map { |user| [user.name, user.id] } 
  end

  def alphabetically_sorted_user_names
    User.all.map { |user| [user.name, user.id]}.sort
  end

  def alphabetically_sort_junior_consultant_names
    JuniorConsultant.all.map { |jc| [jc.name, jc.id] }.sort
  end
end
