module RailsGallery
  module ViewHelper
    def self.galleries
      %w{galleria responsive slideshow touch_touch}
    end

    # autoload all galleries when references
    galleries.each do |gallery|
      autoload gallery.camelize.to_sym, "rails-gallery/view_helper/#{gallery}"
    end

    def gallery_image type, photo
      meth_name = "#{type}gal_image"
      unless respond_to? meth_name
        raise ArgumentError, "Gallery #{type} is not yet supported. Please add a View helper module for this gallery using the convention followed by the other galleries..." 
      end
      send(meth_name, photo)
    end

    def gallery_imageset type, photo
      meth_name = "#{type}gal_imageset"
      unless respond_to? meth_name
        raise ArgumentError, "Gallery #{type} is not yet supported for imageset. Please add a View helper module for this gallery using the convention followed by the other galleries..." 
      end
      send(meth_name, photo)
    end

    protected

    # include view helper modules for all galleries :)
    galleries.each do |gallery|
      include "RailsGallery::ViewHelper::#{gallery.camelize}".constantize
    end
  end
end
