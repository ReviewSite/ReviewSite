module ApplicationHelper
  def full_title(page_title)
    base_title = "Review Website"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def format_all_for_select(model)
    model.all.map { |model_object| [model_object.name, model_object.id] }.sort
  end
end
