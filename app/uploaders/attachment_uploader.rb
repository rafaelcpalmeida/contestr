class AttachmentUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.project_id}/#{model.user_id}"
  end

  #def extension_whitelist
  #  %w(c)
  #end

end
