class WelcomeController < ApplicationController
  skip_authorization_check

  def contributors
  end

  def index
    @reviews = Review.includes(:reviewee).default_load.accessible_by(current_ability)
  end
end