class Project < ApplicationRecord
  def self.project_update(params)
    fields = {}
    languages = self.get_languages(params)

    fields[:languages] = languages.to_json

    if params[:projects][:finish_hour] != ''
      close_time = DateTime.parse("#{params[:projects][:finish_date]} #{params[:projects][:finish_hour]}")
      fields[:closeTime] = close_time.strftime("%Y-%m-%d %H:%M:%S")
    end

    fields[:title] = params[:projects][:name]
    fields[:description] = params[:projects][:description]

    if params[:projects][:file]
      document_id = Document.find_by(project_id: params[:projects][:id]).id
      Document.update_doc(document_id, params[:projects][:file])

      Project.update(params[:projects][:id], fields)
    end

    Project.update(params[:projects][:id], fields)
  end

  def self.create(params, current_user)
    start_time = DateTime.parse("#{params[:projects][:start_date]} #{params[:projects][:start_hour]}")
    formatted_start_time = start_time.strftime("%Y-%m-%d %H:%M:%S")
    close_time = DateTime.parse("#{params[:projects][:finish_date]} #{params[:projects][:finish_hour]}")
    formatted_close_time = close_time.strftime("%Y-%m-%d %H:%M:%S")
    project = Project.new(user_id: current_user.id,
                           title: params[:projects][:name],
                           description: params[:projects][:description],
                           openTime: formatted_start_time,
                           closeTime: formatted_close_time,
                           languages: get_languages(params).to_json)
    project.save
    Document.create(project.id, params[:projects][:file])
    return project
  end

  def self.get_languages(params)
    languages = []

    unless params[:projects][:C].nil?
      languages.push('C')
    end

    unless params[:projects][:Java].nil?
      languages.push('Java')
    end

    unless params[:projects][:Python].nil?
      languages.push('Python')
    end

    unless params[:projects][:PHP].nil?
      languages.push('PHP')
    end

    return languages
  end
end
