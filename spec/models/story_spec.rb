require File.expand_path '../../spec_helper.rb', __FILE__

describe Story do
  describe 'validations' do
    it 'creates record' do
      expect(Story.create!(url: 'http://www.example.com')).to be_persisted
    end

    it 'validates url presence' do
      expect(Story.create(url: nil)).to_not be_valid
    end

    it 'validates url uniqueness' do
      Story.create!(url: 'http://www.example.com')

      expect(Story.create(url: 'http://www.example.com')).to_not be_valid
    end

    it 'validates url format' do
      expect(Story.create(url: '123')).to_not be_valid
    end

    it 'validates scrape_status presence' do
      expect(Story.new(url: 'http://www.example.com', scrape_status: nil)).to_not be_valid
    end

    it 'validates scrape_status in [Pending, Done, Error]' do
      expect(Story.new(url: 'http://www.example.com', scrape_status: 'xxx')).to_not be_valid
    end
  end

end
