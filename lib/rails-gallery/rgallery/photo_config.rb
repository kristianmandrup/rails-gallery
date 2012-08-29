module RGallery
  class PhotoConfig
    attr_writer :photo_class
    attr_reader :options

    def initialize options = {}    
      options ||= {}
      @options = options
      @photo_class = options[:photo_class] if options[:photo_class]
    end

    protected

    def photo_class
      @photo_class ||= RGallery::Photo
    end  
  end
end