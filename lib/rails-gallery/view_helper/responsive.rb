module RailsGallery
  module ViewHelper
    module Responsive
      def responsive_gallery_image photo
        image_tag photo.thumb, :"data-large" => "/assets/#{photo.path}", :alt => photo.alt, :"data-description" => photo.title
      end      
    end
  end
end
