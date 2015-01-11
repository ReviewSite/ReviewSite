class WelcomeController < ApplicationController
  skip_authorization_check

  def contributors
  end

  def index
    @reviews = Review.default_load.accessible_by(current_ability)
  end

end
