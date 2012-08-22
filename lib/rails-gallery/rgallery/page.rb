module RGallery
  class Page < PhotoConfig
    include Enumerable

    def initialize photo_ids = [], options = {}
      @photo_ids = photo_ids
      super options
    end

    def photo_ids
      @photo_ids ||= []
    end   

    def photos
      @photos ||= photo_ids.map {|id| photo_class.new id, options } 
    end   

    delegate :empty?, to: :photos 

    def each &block
      photos.each {|photo| yield photo }
    end    
  end
end