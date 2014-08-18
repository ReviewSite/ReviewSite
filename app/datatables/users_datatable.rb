class UsersDatatable
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
        iTotalRecords: User.count,
        iTotalDisplayRecords: users.total_entries,
        aaData: data
    }
  end

  private

  def data
    users.map do |user|
      [
          h(user.name),
          h(user.email),
          user.ac? ? 'yes' : '' ,
          user.admin ? 'yes' : '',
          (link_to('View Profile', user) unless cannot? :read, user),
          (link_to('Edit', url_helpers.edit_user_path(user)) unless cannot? :edit, user),
          (link_to('Delete', user, method: :delete, data: { confirm: 'Are you sure?' }) unless cannot? :destroy, user)
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.includes(:associate_consultant).order("#{sort_column} #{sort_direction}")
    users = users.paginate(:page => page, :per_page => per_page)

    if params[:sSearch].present?
      users = users.where("users.name ilike :search", search: "%#{params[:sSearch]}%")
    end

    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[name email name admin] # col[n] order_by
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

end
