class UsersController < ApplicationController
  layout 'welcome'

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation).merge(userType: User.exists?(userType: 1) ? 2 : 1)
  end

  def new
  end

  def create
    @user = User.new(user_params)
    if User.where(email: @user.email).empty?
      if @user.save
        ApplicationMailer.register_email(@user).deliver
        session[:user_id] = @user.id
        redirect_to '/login'
      else
        redirect_to '/signup'
      end
    else
      flash[:error] = 'Email already used'
      redirect_to '/signup'
    end
  end
end
