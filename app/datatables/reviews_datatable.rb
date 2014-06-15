class ReviewsDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view
  delegate :can?, :cannot?, to: :@ability

  def initialize(view, user)
    @view = view
    @ability ||= Ability.new(user)
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Review.count,
        iTotalDisplayRecords: reviews.count,
        aaData: data
    }
  end

  private

  def data
    reviews.map do |review|
      [
          h(review.junior_consultant.reviewing_group),
          h(review.junior_consultant.user.name),
          h(review.review_type),
          h(review.review_date),
          h(review.feedback_deadline),
          h("#{review.feedbacks.where(:submitted => true).count} / #{review.feedbacks.count}"),
          (link_to('Email JC', url_helpers.send_email_review_path(review), remote: true, class: "send_email_link") unless cannot? :send_email, Review),
          (link_to('Show Details', review) unless cannot? :read, review),
          (link_to('Feedback Summary', url_helpers.summary_review_path(review)) unless cannot? :summary, review)
      ]
    end
  end

  def reviews
    @reviews ||= fetch_reviews
  end

  def fetch_reviews
    reviews = []

    Review.includes({:junior_consultant => :user},
                    {:junior_consultant => :reviewing_group},
                     :feedbacks).order("#{sort_column} #{sort_direction}").page(page).per_page(per_page).all.each do |review|

      if can? :read, review or can? :summary, review
        reviews << review
      end
    end

    if params[:sSearch].present?
      reviews = reviews.joins(junior_consultant: :user).where("users.name like :search", search: "%#{params[:sSearch]}%")
    end

    reviews
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[reviewing_groups.name users.name review_date review_date feedback_deadline] # col[n] order_by
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    sort_col = params[:iSortCol_0].to_i

    if sort_col == 1 # users.name for some reason returns in reverse order
      params[:sSortDir_0] == "asc" ? "desc" : "asc"
    else
      params[:sSortDir_0] == "desc" ? "desc" : "asc"
    end

  end
end
