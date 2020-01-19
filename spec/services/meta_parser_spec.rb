require File.expand_path '../../spec_helper.rb', __FILE__

describe MetaParser do
  let(:og_file) { File.expand_path '../../support/html/og.html', __FILE__  }

  describe '.call' do
    before do
      allow_any_instance_of(described_class).to receive(:page).and_return(
        OpenGraphReader.parse(
          File.open(og_file).read
        )
      )
    end

    it 'returns data' do
      expect(described_class.call('http://www.example.com')).to eq(
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
end
