module RailsGallery
  module ViewHelper
    module Slideshow
      def slideshow_gallery_image photo
        image_tag photo.thumb, alt: "/assets/#{photo.path}"
      end
    end
  end
end
