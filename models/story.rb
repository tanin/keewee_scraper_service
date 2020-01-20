require File.expand_path '../../services/canonical_url_retriever.rb', __FILE__

class Story
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = [
    'Pending',
    'Done',
    'Error',
    nil
  ].freeze

  field :url, type: String
  field :scrape_status, type: String
  field :meta_data, type: Hash

  validates :url, presence: true, uniqueness: true, format: { with: URI::regexp(%w(http https)) }
  validates :scrape_status, inclusion: { in: STATUSES }

  index({ url: 'text' }, { unique: true, name: 'url_index' })

  before_validation :assign_url, on: :create

  def scrape!
    self.meta_data = MetaParser.call(url)
    self.scrape_status = result_status

    save!
  end

  protected

  def result_status
    meta_data.blank? ? 'Error' : 'Done'
  end

  def assign_url
    # will not pass validation if url already exists
    self.url = CanonicalUrlRetriever.call(url)
  end
end
