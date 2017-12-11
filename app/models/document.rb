class Document < ApplicationRecord
  def self.create(id, file)
    document = Document.new(project_id: id,
                            filename: File.basename(file.original_filename),
                            content_type: file.content_type,
                            file_contents: file.read)

    if document.save
      return true
    end
    return false
  end

  def self.update_doc(id, file)
    if Document.update(id: id, filename: File.basename(file.original_filename),
                       content_type: file.content_type,
                       file_contents: file.read)
      return true
    end
    return false
  end
end
