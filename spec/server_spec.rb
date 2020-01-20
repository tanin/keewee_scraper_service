require File.expand_path './spec/spec_helper.rb'

describe 'API' do
  describe 'POST /stories' do
    context 'when success' do
      it 'creates site and return json' do
        # stub external request
        allow(CanonicalUrlRetriever).to receive(:call).and_return('http://www.example.com')

        post '/stories?url=http://www.example.com'

        expect(last_response.status).to eq(201)

        json = JSON.parse(last_response.body, symbolize_names: true)
        expect(json[:url]).to eq('http://www.example.com')
        expect(json[:id]).to be
      end
    end

    context 'when fail' do
      it 'returns json with error' do
        Story.create(url: 'http://www.example.com')

        # stub external request
        allow(CanonicalUrlRetriever).to receive(:call).and_return('http://www.example.com')

        post '/stories?url=http://www.example.com'

        expect(last_response.status).to eq(422)
        json = JSON.parse(last_response.body, symbolize_names: true)
        expect(json[:errors][:url]).to eq(['is already taken'])
      end
    end
  end

  describe 'GET /stories' do
    context 'when not found' do
      it 'returns 404' do
        get '/stories/123'
        expect(last_response.status).to eq(404)
      end
    end

    context 'when found and not yet scraped' do
      it 'calls scrape! and returns json' do
        story = Story.create(url: 'http://www.example.com')

        get "/stories/#{story.id}"

        expect(last_response.status).to eq(200)
        json = JSON.parse(last_response.body, symbolize_names: true)
        expect(json[:scrape_status]).to eq('Pending')
      end
    end

    context 'when found and already scraped' do
      it 'doesn\'t call scrape and returns scraped json' do
        story = Story.create(
          url: 'http://www.example.com',
          scrape_status: 'Done',
          meta_data: {
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

        get "/stories/#{story.id}"

        expect(last_response.status).to eq(200)
        json = JSON.parse(last_response.body, symbolize_names: true)
        expect(json[:scrape_status]).to eq('Done')
        expect(json[:title]).to eq('Open Graph protocol')
      end
    end
  end
end
