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
        base_scheme = uri_scheme(url)

        temp_url =
          page.at('link[rel=canonical]')&.attributes&.dig('href')&.value ||
          page.at('meta[property="og:url"]')&.attributes&.dig('content')&.value ||
          url

        canonical_url_scheme = uri_scheme(temp_url)
        temp_url.gsub!(canonical_url_scheme, base_scheme) unless base_scheme == canonical_url_scheme

        temp_url
      end
  end

  def uri_scheme(url)
    uri = URI.parse(url)
    uri.scheme
  end

  def page
    @page ||= Nokogiri::HTML(open(url))
  end
end
