class SessionsController < ApplicationController
  skip_before_filter :require_login, only: [:callback]
  skip_authorization_check

  def callback
    session[:userinfo] = request.env['omniauth.auth'].uid
    redirect_back_or(root_url)
  end

  def set_temp_okta
    self.current_okta_name = params["temp-okta"]
    redirect_to root_url
  end
end
