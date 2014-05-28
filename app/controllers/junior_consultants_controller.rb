class JuniorConsultantsController < ApplicationController
  load_and_authorize_resource

  def autocomplete_jc_name
    jc_names = JuniorConsultant.select([:name]).where("name ILIKE ?", "%#{params[:name]}%")
    @result = jc_names.collect { |jc| {value: jc.user.name}  }
    render json: @result
  end

end
