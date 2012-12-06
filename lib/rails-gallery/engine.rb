module RailsGallery
  module Rails
    class Engine < ::Rails::Engine
      initializer 'rails gallery' do
        # puts "Adding RailsGallery::ViewHelper"
        ActionView::Base.send :include, RailsGallery::ViewHelper
      end
    end
  end
end