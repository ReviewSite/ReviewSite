module ApplicationHelper
  def full_title(page_title)
    base_title = "Review Site"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def format_all_for_select(model)
    model.all.map { |model_object| [model_object.name, model_object.id] }.sort
  end

  def list(collection)
    collection.map { |item| item.to_s }.sort.join(', ')
  end

  def to_yes_no_string(boolean)
    boolean ? "Yes" : "No"
  end

end
