class ActionView::Helpers::FormBuilder
  alias :orig_label :label

  # add a '*' after the field label if the field is required
  def label(method, content_or_options = nil, options = nil, &block)
    if content_or_options && content_or_options.class == Hash
      options = content_or_options
    else
      content = content_or_options
    end

    required_mark = ""

    if !object.nil? && object.class.validators_on(method).map(&:class).include?(ActiveModel::Validations::PresenceValidator)

      required_mark = "<span class=\"required\"> *</span>".html_safe
    end

    content ||= method.to_s.humanize
    content = (content + required_mark).html_safe

    self.orig_label(method, content, options || {}, &block)
  end
end
