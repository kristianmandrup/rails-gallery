module RGallery
  class Photo
    attr_reader :id, :options

    def initialize id, options = {}
      @id = id
      @options = options
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