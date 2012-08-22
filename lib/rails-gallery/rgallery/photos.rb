require 'enumerator'

module RGallery
  class Photos < PhotoConfig  
    def initialize pages = nil, options = {}
      unless pages.nil?
        raise ArgumentError, "Must be a Photos::Pages or Array, was: #{pages}" unless valid_pages? pages
        pages = pages_class.new pages, options if pages.kind_of?(Array)
        @pages = pages
      end
      super options
    end

    def all
      pages.inject([]) {|res, page| res += page.photos }.flatten.compact
    end

    def pages
      @pages ||= pages_class.new nil, options
    end

    def page id
      raise ArgumentError, "Page id must be one #{valid_page_ids}, was: #{id}" unless valid_page_id? id
      pages.send(id)
    end

    protected

    def valid_page_id? id
      [:first].include? id.to_sym
    end

    def valid_page_ids
      [:first]
    end

    def valid_pages? pages
      pages.kind_of?(pages_class) || pages.kind_of?(Array)
    end

    def pages_class
      RGallery::Pages
    end
  end
end