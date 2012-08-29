module RGallery
  class Pages < PhotoConfig
    include Enumerable

    def initialize photo_list = [], options = {}
      super options
      self.send(:<<, photo_list) unless photo_list.blank?
    end

    def each &block
      pages.each {|page| yield page }
    end

    def remainder
      pages[1..-1] || []
    end

    def first
      pages.first || []
    end

    def << photo_list
      pages << RGallery::Page.new(photo_list, options)
    end

    # a source is a hash of the form:
    # 'banner' => [{src: 'banner-HD', sizing: '2x'}, {src: 'banner-phone', sizing: '100w'}]
    def add_photo_w_sources source
      pages << RGallery::Page.from_source(source, options)
    end

    # a Hash where each element is a source of the form:
    # 'banner' => [{src: 'banner-HD', sizing: '2x'}, {src: 'banner-phone', sizing: '100w'}]
    def add_photo_sources sources_hash
      sources_hash.each do |source|
        pages.add_photo_w_sources source
      end
    end


    delegate :empty?, to: :pages

    protected

    def pages
      @pages ||= []
    end    
  end
end