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

    delegate :empty?, to: :pages

    protected

    def pages
      @pages ||= []
    end    
  end
end