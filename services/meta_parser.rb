require 'open-uri'
require 'open_graph_reader'
require File.expand_path '../../lib/open_graph_definitions.rb', __FILE__

class MetaParser
  attr_accessor :url, :page, :meta_data

  class << self
    def call(url)
      new(url).call
    end
  end

  def call
    meta_data
  end

  protected

  def initialize(url)
    @url = url
  end

  def page
    @page ||= OpenGraph.fetch!(url)
  end

  def meta_data
    @meta_data ||= {
      url: page.og.url,
      title: page.og.title,
      type: page.og.type,
      images: images(page.og.images)
    }
  end

  def images(array)
    array.map do |image|
      {
        url: image.url,
        type: image.type,
        width: image.width,
        height: image.height,
        alt: image.alt
      }
    end
  end
end
