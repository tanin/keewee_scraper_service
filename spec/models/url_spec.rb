require File.expand_path '../../spec_helper.rb', __FILE__

describe Url do
  it 'creates record' do
    expect(Url.create!(canonical: 'http://www.example.com')).to be_persisted
  end

  it 'validates canonocal presence' do
    expect(Url.create(canonical: nil)).to_not be_valid
  end

  it 'validates canonocal uniqueness' do
    Url.create!(canonical: 'http://www.example.com')

    expect(Url.create(canonical: 'http://www.example.com')).to_not be_valid
  end
end
