module RailsGallery
  class ConfigurationError < StandardError
  end

  module ViewHelper
    include RailsGallery::PhotoValidation

    def self.galleries
      %w{galleria responsive slideshow touch_touch}
    end

    def self.version
      '0.2.2'
    end

    # autoload all galleries when references
    galleries.each do |gallery|
      autoload gallery.camelize.to_sym, "rails-gallery/view_helper/#{gallery}"
    end

    def gallery_image type, photo, options = {}
      meth_name = "#{type}_gallery_image"
      validate_gallery_photo! photo
      unless respond_to? meth_name
        raise ArgumentError, "Gallery #{type} is not yet supported. Please add a View helper module for this gallery using the convention followed by the other galleries..." 
      end
      send(meth_name, photo, options)
    end

    def gallery_imageset type, imageset, options = {}
      meth_name = "#{type}_gallery_imageset"
      # validate_gallery_imageset! imageset
      unless respond_to? meth_name
        raise ArgumentError, "Gallery #{type} is not yet supported for imageset. Please add a View helper module for this gallery using the convention followed by the other galleries..." 
      end
      send(meth_name, imageset, options)
    end

    protected

    # include view helper modules for all galleries :)
    galleries.each do |gallery|
      include "RailsGallery::ViewHelper::#{gallery.camelize}".constantize
    end
  end
end
