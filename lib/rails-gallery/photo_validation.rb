module RailsGallery
  module PhotoValidation
    def validate_gallery_photo photo
      return "Photo must be a kind of RGallery::Photo, was: #{photo}" unless photo.kind_of?(RGallery::Photo)
      return 'Photo must have a #path method' unless photo.respond_to? :path
      return 'Photo must have a #title method' unless photo.respond_to? :title

      begin
        photo.filename
        photo.file_path
      rescue Exception => e
        return "filename or file_path could not be resolved for: #{photo}, cause: #{e}"
      end

      return "Photo must have a path: #{photo}" if photo.path.blank?
      return "Photo must have a title: #{photo}" if photo.title.blank?
      true
    end

    def validate_gallery_photo! photo
      raise ArgumentError, "Photo must be a kind of RGallery::Photo, was: #{photo}" unless photo.kind_of?(RGallery::Photo)
      raise ArgumentError, 'Photo must have a #path method' unless photo.respond_to? :path
      raise ArgumentError, 'Photo must have a #title method' unless photo.respond_to? :title

      begin
        photo.filename
        photo.file_path
      rescue Exception => e
        raise ::RailsGallery::ConfigurationError, "filename or file_path could not be resolved for: #{photo}, cause: #{e}"
      end

      raise ArgumentError, "Photo must have a path: #{photo}" if photo.path.blank?
      raise ArgumentError, "Photo must have a title: #{photo}" if photo.title.blank?
      true
    end
  end
end