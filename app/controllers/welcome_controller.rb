class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    @reviews = []
    Review.all.each do |review|
      if can? :read, review
        @reviews << review
      end
    end
  end

  def help
  end
end
