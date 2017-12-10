class DashboardController < ApplicationController
  before_action :authorize

  def index
    @page = 'index'
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    query = "closeTime > '#{current_time}'"
    @projects = Project.where(query)
    @submissions = Submission.where(:user_id => current_user.id)
  end

  def closed
    @page = 'closed'
    current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    query = "closeTime < '#{current_time}'"
    @projects = Project.where(query)
    @submissions = Submission.where(:user_id => current_user.id)
  end
end
