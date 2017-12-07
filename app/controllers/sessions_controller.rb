class SessionsController < ApplicationController
  layout 'welcome'

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to '/dashboard'
    else
      flash[:error] = 'Email ou password errada.'
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

  def new
    if User.all.empty?
      redirect_to '/signup'
    end
  end
end
