class WelcomeController < ApplicationController
  layout 'welcome'

  def index
    redirect_to signup_path unless User.exists?(userType: 1)
  end
end
