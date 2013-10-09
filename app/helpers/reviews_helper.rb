module ReviewsHelper
  def alphabetically_sort_junior_consultant_names
    JuniorConsultant.all.map { |jc| [jc.name, jc.id]  }.sort
  end
end
