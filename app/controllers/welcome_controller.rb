class WelcomeController < ApplicationController
  layout 'application'

  def index
    redirect_to signup_path unless User.exists?(userType: 1)
  end
end
