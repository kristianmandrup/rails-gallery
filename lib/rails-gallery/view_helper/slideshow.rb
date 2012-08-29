module RailsGallery
  module ViewHelper
    module Slideshow
      def slidegal_image photo, options = {}
        image_tag photo.thumb, options.merge(alt: photo.path)
      end

      def slidegal_imageset photo, srcset, options = {}
        imageset_tag photo.thumb, options.merge(alt: photo.path, :srcset => srcset)
      end
    end
  end
end
