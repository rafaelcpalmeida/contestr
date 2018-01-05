class ProjectsController < ApplicationController
  before_action :authorize

  layout 'dashboard'
  require 'date'

  def new
    @page = 'new'
  end

  def create
    project = Project.create(params, current_user)
    doc = Document.find_by(project_id: project.id)
    users = User.where(userType: 2).to_a
    if doc.nil?
      Thread.new do
        users.each do |user|
          ApplicationMailer.new_project(project, user).deliver
        end
      end
    else
      attachments[doc.filename] = { mime_type: doc.content_type, content: doc.file_contents }
      Thread.new do
        users.each do |user|
          ApplicationMailer.new_project_with_pdf(project, user.email,
                                                 user.name, attachments).deliver
        end
      end
    end


    redirect_to '/dashboard'
  end

  def submissions
    @submissions = Submission.where(project_id: params[:id])
    @title = Project.find(params[:id]).title
  end

  def code
    full_path = Submission.find(params[:id]).attachment
    filename_array = full_path.split '/'
    filename = filename_array[filename_array.size - 1]

    send_file("#{Rails.root}/#{full_path}",
              filename: "#{filename}",
              type: 'text/plain'
    )
  end

  def delete
    Project.find(params[:id]).destroy
    Submission.where(project_id: params[:id]).destroy_all
    redirect_to '/dashboard'
  end

  def show
    @project = Project.find(params[:id])
    @document = Document.find_by(project_id: @project.id)
    languages_array = ActiveSupport::JSON.decode(@project.languages)

    @languages = languages_array.join(', ')
  end

  def send_document
    doc = Document.find_by(project_id: params[:id])
    send_data(doc.file_contents, type: doc.content_type, filename: doc.filename)
  end

  def edit
    @project = Project.find(params[:id])
    @document = Document.find_by(project_id: @project.id)
    @close_date = @project.closeTime.strftime('%Y-%m-%d')
    @languages = ActiveSupport::JSON.decode(@project.languages)
  end

  def update
    if Project.project_update(params)
      redirect_to '/dashboard'
    end
  end

  def details
    show
  end

  def certificate
    @title = Project.find(params[:id]).title
    @username = current_user.name
    @date = Time.now.strftime('%d/%m/%Y')
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'certificate',
               layout: 'certificate',
               orientation: 'Landscape',
               page_size: 'A4',
               margin: { top: 7,
                         bottom: 4,
                         left: 15,
                         right: 15
               }
      end
    end
  end
end
