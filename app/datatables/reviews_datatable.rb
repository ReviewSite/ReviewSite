class ReviewsDatatable
  delegate :params, :h, :link_to, to: :@view
  delegate :can?, :cannot?, to: :@ability

  def initialize(view, ability)
    @view = view
    @ability ||= ability
  end

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Review.count,
        iTotalDisplayRecords: reviews.total_entries,
        aaData: data
    }
  end

  private

  def data
    reviews.map do |review|
      [
          # h(review.associate_consultant.reviewing_group),
          h(review.associate_consultant.user.name),
          h(review.review_type),
          h(review.review_date),
          # h("#{review.feedbacks.where(:submitted => true).count} / #{review.feedbacks.count}"),
          (link_to('', review, class: "fa fa-eye fa-lg"))
      ]
    end
  end

  def reviews
    @reviews ||= fetch_reviews
  end

  def fetch_reviews
    reviews = Review.default_load
    reviews = reviews.order("#{sort_column} #{sort_direction}, users.name asc, review_date asc")

    if params[:sSearch].present?
      reviews = reviews.joins(associate_consultant: :user).where("users.name ilike :search", search: "%#{params[:sSearch]}%")
    end

    reviews = reviews.accessible_by(@ability).paginate(:page => page, :per_page => per_page)
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[users.name review_date review_date feedback_deadline] # col[n] order_by
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end
