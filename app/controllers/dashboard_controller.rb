class DashboardController < ApplicationController
  before_action :authorize

  def index
    @page = 'index'
    @projects = Project.where("closeTime > :current_time", {current_time: Time.now.strftime("%Y-%m-%d %H:%M:%S")})
    @submissions = Submission.where(user_id: current_user.id)
  end

  def closed
    @page = 'closed'
    @projects = Project.where("closeTime < :current_time", {current_time: Time.now.strftime("%Y-%m-%d %H:%M:%S")})
    @submissions = Submission.where(user_id: current_user.id)
  end

  def positions
    project = Project.find(params[:id])
    @positions = Array.new
    i = 1
    evaluations = Evaluation.where(project_id: project.id, build_result: 'ok', run_result: project.result).order(execution_time: :asc)

    evaluations.each do |t|
      @positions << { name: User.find(t.user_id).name, pos: i, exec_time: t.execution_time }
      i += 1
    end
  end
end
