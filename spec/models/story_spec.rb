require File.expand_path '../../spec_helper.rb', __FILE__

describe Story do
  before do
    allow(CanonicalUrlRetriever).to receive(:call).and_return('http://www.example.com')
  end

  it 'creates record' do
    expect(Story.create!(url: 'https://www.example.com')).to be_persisted
  end

  describe 'validations' do
    it 'validates url presence' do
      allow(CanonicalUrlRetriever).to receive(:call).and_return(nil)
      expect(Story.create(url: nil)).to_not be_valid
    end

    it 'validates url uniqueness' do
      Story.create!(url: 'http://www.example.com')

      expect(Story.create(url: 'http://www.example.com')).to_not be_valid
    end

    it 'validates url format' do
      allow(CanonicalUrlRetriever).to receive(:call).and_return('123')
      expect(Story.create(url: '123')).to_not be_valid
    end

    it 'validates scrape_status in [Pending, Done, Error, nil]' do
      expect(Story.new(url: 'http://www.example.com', scrape_status: 'xxx')).to_not be_valid
    end
  end

  describe '#scrape!' do
    context 'when success' do
      let(:og_file) { File.expand_path '../../support/html/og.html', __FILE__  }

      before do
        allow_any_instance_of(MetaParser).to receive(:page).and_return(
          OpenGraphReader.parse(
            File.open(og_file).read
          )
        )
      end

      it 'assigns meta_data and sets scrape_status to done' do
        story = Story.create!(url: 'http://www.example.com')

        story.scrape!

        expect(story.scrape_status).to eq('Done')
        expect(story.meta_data).to eq(
          {
            url: 'http://ogp.me/',
            title: 'Open Graph protocol',
            type: 'website',
            images: [
              {
                url: 'http://ogp.me/logo.png',
                type: 'image/png',
                width: 300,
                height: 300,
                alt: 'The Open Graph logo'
              },
              {
                url: 'http://ogp.me/logo_1.png',
                type: 'image/png',
                width: 300,
                height: 400,
                alt: 'The Open Graph logo 1'
              }
            ]
          }
        )
      end
    end

    context 'when fail' do
      let(:no_meta_file) { File.expand_path '../../support/html/no_meta.html', __FILE__  }

      before do
        allow_any_instance_of(MetaParser).to receive(:page).and_return(
          OpenGraphReader.parse( File.open(no_meta_file).read)
        )
      end

      it 'sets status to error' do
        story = Story.create!(url: 'http://www.example.com')

        story.scrape!

        expect(story.scrape_status).to eq('Error')
      end
    end
  end
end
