module RailsGallery
  module ViewHelper
    module Galleria
      def galleria_gallery_image photo
        content_tag :a, href: "/assets/#{photo.path}" do
          image_tag photo.path, :"data-title" => photo.title, :"data-description" => photo.description
        end
      end
    end
  end
end
