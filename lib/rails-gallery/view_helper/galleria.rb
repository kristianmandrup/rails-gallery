module RailsGallery
  module ViewHelper
    module Galleria
      def galleria_image photo, options = {}
        content_tag :a, href: photo.path do
          options.merge! :"data-title" => photo.title, :"data-description" => photo.description
          image_tag photo.path, options
        end
      end

      def galleria_image photo, srcset, options = {}
        content_tag :a, href: photo.path do
          options.merge! :"data-title" => photo.title, :"data-description" => photo.description
          options.merge! :srcset => srcset
          image_tag photo.path, options
        end
      end
    end
  end
end
