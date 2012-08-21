require 'enumerator'
require 'rails-gallery/photo_config'

class Photos < PhotoConfig  
  def initialize pages = nil, options = {}
    unless pages.nil?
      raise ArgumentError, "Must be a Photos::Pages or Array, was: #{pages}" unless valid_pages? pages
      pages = Pages.new pages, options if pages.kind_of?(Array)
      @pages = pages
    end
    super options
  end

  def all
    pages.inject([]) {|res, page| res += page.photos }.flatten.compact
  end

  def pages
    @pages ||= Pages.new nil, options
  end

  def page id
    raise ArgumentError, "Page id must be one #{valid_page_ids}, was: #{id}" unless valid_page_id? id
    pages.send(id)
  end

  def valid_page_id? id
    [:first].include? id.to_sym
  end

  def valid_page_ids
    [:first]
  end

  def valid_pages? pages
    pages.kind_of?(Photos::Pages) || pages.kind_of?(Array)
  end

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
      pages << Page.new(photo_list, options)
    end

    delegate :empty?, to: :pages

    protected

    def pages
      @pages ||= []
    end    
  end

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

  class Photo
    attr_reader :id, :options

    def initialize id, options = {}
      @id = id
      @options = options
    end

    def file_path
      "#{id}.#{extension}"
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