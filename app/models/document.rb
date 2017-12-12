class Document < ApplicationRecord
  def self.create(id, file)
    unless file.nil?
      document = Document.new(project_id: id,
                            filename: File.basename(file.original_filename),
                            content_type: file.content_type,
                            file_contents: file.read)
      document.save
    end
  end

  def self.update_doc(id, file)
    Document.update(id: id,
                    filename: File.basename(file.original_filename),
                    content_type: file.content_type,
                    file_contents: file.read)
  end
end
