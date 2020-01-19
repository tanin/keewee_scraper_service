require 'open-uri'
require 'nokogiri'

class CanonicalUrlRetriever
  attr_accessor :url, :page

  class << self
    def call(url)
      new(url).call
    end
  end

  def call
    canonical_url
  end

  protected

  def initialize(url)
    @url = url
  end

  def canonical_url
    @canonical_url ||=
      begin
        page.at('link[rel=canonical]')&.attributes&.dig('href')&.value ||
        page.at('meta[property="og:url"]')&.attributes&.dig('content')&.value ||
        url
      end
  end

  def page
    @page ||= Nokogiri::HTML(open(url))
  end
end
