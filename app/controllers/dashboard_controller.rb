class DashboardController < ApplicationController
  before_action :authorize

  def index
    @projects = Project.all
    @submissions = Submission.where(:user_id => current_user.id)
  end
end
