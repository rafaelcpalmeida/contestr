class ProjectsController < ApplicationController
  before_action :authorize
  layout 'dashboard'

  require 'date'

  def new

  end

  def create
    start_time = DateTime.parse("#{params[:projects][:start_date]} #{params[:projects][:start_hour]}")
    formatted_start_time = start_time.strftime("%Y-%m-%d %H:%M:%S")
    close_time = DateTime.parse("#{params[:projects][:finish_date]} #{params[:projects][:finish_hour]}")
    formatted_close_time = close_time.strftime("%Y-%m-%d %H:%M:%S")

    project = Project.new({:user_id => current_user.id, :title => params[:projects][:name], :description => params[:projects][:description], :openTime => formatted_start_time, :closeTime => formatted_close_time})

    if project.save
      redirect_to '/dashboard'
    end
  end

  def delete
    Project.find(params[:id]).destroy
    Submission.where(project_id: params[:id]).destroy_all
    redirect_to '/dashboard'
  end

  def show
    @project = Project.find(params[:id])
  end
end
