class PasswordResetsController < ApplicationController
  skip_authorization_check only: [:new, :create]
  
  def new
  end

  def create
  end
end
