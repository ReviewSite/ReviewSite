class AssociateConsultantsController < ApplicationController
load_and_authorize_resource

def index

  name = "%#{params[:q]}%"

  @associate_consultants = AssociateConsultant.joins(:user).where("users.name ILIKE ?", name).where(graduated: [false, nil])

  respond_to do |format|
    format.json { render :json => @associate_consultants.map{ |ac| {:id => ac.id, :name => ac.user.name} } }
  end
end

end
