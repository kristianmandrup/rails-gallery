module RGallery
  class Photo
    attr_reader :obj, :sizing, :sources, :options

    def initialize obj, options = {}
      @obj = obj
      self.sources = options.delete :sources
      @sizing = options.delete :sizing
      @options = options
    end

    alias_method :id, :obj

    # map [{src: 'banner-HD.jpeg', sizing: '2x'}, {src: 'banner-phone.jpeg', sizing: '100w'}]
    # into -> "banner-HD.jpeg 2x, banner-phone.jpeg 100w
    def srcset
      return '' unless sources_photos.kind_of? Array
      @srcset ||= source_photos.inject([]) do |res, photo| 
        res << [photo.id, photo.sizing].join(' ')
      end.join(',')
    end

    def srcset?
      !srcset.blank?
    end

    # A photo can contain a source set of other photos!
    def source_photos
      return [] unless sources.kind_of? Array
      @source_photos ||= sources.map do |source| 
        RGallery::Photo.new source.src, options.merge(:sizing => source.sizing)
      end
    end

    # make sure that sources are wrapped as Hashies to allow method access
    def sources= sources = []
      return unless sources.kind_of? Array
      @sources = sources.map{|source| Hashie::Mash.new source }
    end

    def filename
      id
    end

    def file_path
      "#{filename}.#{extension}"
    end

    def path
      file_path
    end

    def thumb
      path
    end

    def title
      'no title'
    end

    def alt
      'no alt'
    end

    def description
      'no description'
    end

    def extension
      options[:extension] || self.class.extension
    end

    class << self
      attr_writer :extension

      def extension
        @extension ||= :png
      end
    end
  end
end