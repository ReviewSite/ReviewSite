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

      if user.ac?
        ac_icon = "<span class='fa fa-book fa-fw' title='AC'></span>"
        if user.ac? && user.associate_consultant.hasGraduated?
          ac_icon = "<span class='fa fa-graduation-cap fa-fw' title='Graduated AC'></span>"
        end
      else
        ac_icon = ""
      end

      # ac_icon = (user.ac? && user.associate_consultant.hasGraduated?) ? "<span class='fa fa-graduation-cap fa-fw' title='AC'></span>" : ""
      admin_icon = user.admin? ? "<span class='fa fa-key fa-fw' title='Admin'></span>" : ""

      [
        h("#{user.name} #{ac_icon} #{admin_icon}".html_safe),

        h(user.email),

        h("<ul>
            <li>#{(link_to('', user, class: "fa fa-eye fa-lg fa-fw", title: "View") unless cannot? :read, user)}</li>
            <li>#{(link_to('', url_helpers.edit_user_path(user), class: "fa fa-pencil fa-lg fa-fw", title: "Edit") unless cannot? :edit, user)}</li>
            <li>#{(link_to('', user, method: :delete, data: { confirm: 'Are you sure you want to delete this user?' }, class: "fa fa-trash fa-lg fa-fw", title: "Delete") unless cannot? :destroy, user)}</li>
          </ul>".html_safe)
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
