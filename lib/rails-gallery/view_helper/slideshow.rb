module RailsGallery
  module ViewHelper
    module Slideshow
      def slidegal_image photo, options = {}
        options.merge! alt: photo.path
        image_tag photo.thumb, options
      end

      def slidegal_imageset photo, options = {}
        options.merge! alt: photo.path
        options.merge! :srcset => photo.srcset if photo.srcset?
        imageset_tag photo.thumb, options
      end

      alias_method :slideshow_gallery_image, :slidegal_image
      alias_method :slideshow_gallery_imageset, :slidegal_imageset
    end
  end
end
