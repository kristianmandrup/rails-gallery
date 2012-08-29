module RailsGallery
  module ViewHelper
    module Galleria
      def riagal_image photo, options = {}
        content_tag :a, href: photo.path do
          options.merge! :"data-title" => photo.title, :"data-description" => photo.description
          image_tag photo.path, options
        end
      end

      def riagal_imageset photo, options = {}
        content_tag :a, href: photo.path do
          options.merge! :"data-title" => photo.title, :"data-description" => photo.description
          options.merge! :srcset => photo.srcset if photo.srcset?
          image_tag photo.path, options
        end
      end
      alias_method :galleria_gallery_image, :riagal_image
      alias_method :galleria_gallery_imageset, :riagal_imageset      
    end
  end
end
