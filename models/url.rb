class Url
  include Mongoid::Document

  field :canonical, type: String
  validates :canonical, presence: true, uniqueness: true

  index({ canonical: 'text' }, { unique: true, name: 'canonical_index' })
end
