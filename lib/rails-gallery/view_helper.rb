module RailsGallery
  module ViewHelper
    def gallery_image type, photo
      send("#{type}_gallery_image", photo)
    end

    protected

    def responsive_gallery_image photo
      image_tag photo.thumb, :"data-large" => "/assets/#{photo.path}", :alt => photo.alt, :"data-description" => photo.title
    end

    def slideshow_gallery_image photo
      image_tag photo.thumb, alt: "/assets/#{photo.path}"
    end

    def glleria_gallery_image photo
      content_tag :a, href: "/assets/#{photo.path}" do
        image_tag photo.path, :"data-title" => photo.title, :"data-description" => photo.description
      end
    end
  end
end
