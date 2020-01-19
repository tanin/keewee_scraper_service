require File.expand_path './spec/spec_helper.rb'

describe 'API' do
  context 'when success' do
    it 'should create site and return json' do
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
    it 'should create site and return json' do
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
