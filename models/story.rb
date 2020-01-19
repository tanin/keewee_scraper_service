require 'open-uri'
require 'nokogiri'

class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = [
    'Pending',
    'Done',
    'Error'
  ].freeze

  field :url, type: String
  field :scrape_status, type: String, default: 'Pending'

  validates :url, presence: true, uniqueness: true, format: { with: URI::regexp(%w(http https)) }
  validates :scrape_status, presence: true, inclusion: { in: STATUSES }

  index({ url: 'text' }, { unique: true, name: 'url_index' })

  #before_validation :assign_url, on: :create

  protected

  def assign_url
    self.url = page.at('link[rel=canonical]')['href']
    self.scrape_status = 'Pending'
  end

  def page
    @page ||= Nokogiri::HTML(open(url))
  end
end
