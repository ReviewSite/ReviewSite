class JuniorConsultantsController < ApplicationController
load_and_authorize_resource

def index

  name = "%#{params[:q]}%"

  @junior_consultants = JuniorConsultant.joins(:user).where("users.name ILIKE ?", name )

  respond_to do |format|
    format.json { render :json => @junior_consultants.map{ |jc| {:id => jc.id, :name => jc.user.name} } }
  end
end

end
