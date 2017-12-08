class DashboardController < ApplicationController
  before_action :authorize

  def index
    @page = 'index'
    @projects = Project.where("closeTime > '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'")
    @submissions = Submission.where(:user_id => current_user.id)
  end

  def closed
    @page = 'closed'
    @projects = Project.where("closeTime < '#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'")
    @submissions = Submission.where(:user_id => current_user.id)
  end
end
