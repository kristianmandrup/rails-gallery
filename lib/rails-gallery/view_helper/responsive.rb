module RailsGallery
  module ViewHelper
    module Responsive
      def respgal_image photo, options = {}
        options.merge! :alt => photo.alt
        options.merge! :"data-large" => photo.path, :"data-description" => photo.title
        return image_tag photo.thumb, options unless options.delete :wrap
        
        content_tag :li do
          content_tag :a, href: '#' do
            image_tag(photo.thumb, options)
          end
        end          
      end      

      def respgal_imageset photo, srcset, options = {}
        options.merge! :alt => photo.alt
        options.merge! :"data-large" => photo.path, :"data-description" => photo.title
        options.merge! :srcset => srcset
        return imageset_tag photo.thumb, options unless options.delete :wrap
        
        content_tag :li do
          content_tag :a, href: '#' do
            imageset_tag(photo.thumb, options)
          end
        end
      end
    end
  end
end
