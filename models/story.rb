require File.expand_path '../../services/meta_parser.rb', __FILE__
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

  def scrape_in_backgrouund
    Thread.new do # trivial work thread
      while true do
        sleep 0.12

        $semaphore.synchronize do
          scrape!
        end
      end
    end
  end

  def scrape!
    begin
      self.meta_data = MetaParser.call(url)
      self.scrape_status = result_status
    rescue
      self.scrape_status = 'Error'
    ensure
      save!
    end
  end

  def scrape_done?
    scrape_status == 'Done'
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
