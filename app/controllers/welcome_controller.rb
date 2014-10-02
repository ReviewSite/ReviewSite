class WelcomeController < ApplicationController
  skip_authorization_check

  def contributors
  end


  def index
    redirect_to signup_path unless signed_in?
  end

  def test_error
    raise NotImplementedError, "This controller action breaks on purpose."
  end
end
