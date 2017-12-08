class ProjectsController < ApplicationController
  before_action :authorize

  layout 'dashboard'
  require 'date'

  def new
    @page = 'new'
  end

  def create
    if Project.create(params, current_user)
      redirect_to '/dashboard'
    end
  end

  def submissions
    @submissions = Submission.where(:project_id => params[:id])
    @title = Project.find(params[:id]).title
  end

  def code
    full_path = Submission.find(params[:id]).attachment
    filename_array = full_path.split "/"
    filename = filename_array[filename_array.size - 1]

    send_file(
        "#{Rails.root}/#{full_path}",
        filename: "#{filename}",
        type: "text/html"
    )
  end

  def delete
    Project.find(params[:id]).destroy
    Submission.where(project_id: params[:id]).destroy_all
    redirect_to '/dashboard'
  end

  def show
    @project = Project.find(params[:id])
    @document = Document.find_by(:project_id => @project.id)
    languages_array = ActiveSupport::JSON.decode(@project.languages)

    if languages_array.size() == 1
      @languages = languages_array.join('')
    else
      @languages = languages_array.join(', ')
    end

  end

  def send_document
    doc = Document.find_by(:project_id => params[:id])
    send_data(doc.file_contents, type: doc.content_type, filename: doc.filename)
  end

  def edit
    @project = Project.find(params[:id])
    @document = Document.find_by(:project_id => @project.id)
    @close_date = @project.closeTime.strftime('%Y-%m-%d')
    @languages = ActiveSupport::JSON.decode(@project.languages)
  end

  def update
    if Project.project_update(params)
      redirect_to '/dashboard'
    end
  end

  def details
    show()
  end

  # How to use Sonar DB
  # Sonar.table_name = 'projects' -> table name
  # @test = Sonar.all -> query to table
end
