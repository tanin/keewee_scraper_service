require File.expand_path '../../spec_helper.rb', __FILE__

describe Story do
  let(:canonical_file) { File.expand_path '../../support/html/canonical.html', __FILE__  }
  let(:og_file) { File.expand_path '../../support/html/og.html', __FILE__  }
  let(:no_meta_file) { File.expand_path '../../support/html/no_meta.html', __FILE__  }

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

  describe '#assign_url' do
    before do
      allow(story).to receive(:page).and_return(Nokogiri::HTML(File.open(canonical_file)))
    end

    context 'when url contains rel=canonical' do
      before do
        allow(story).to receive(:page).and_return(Nokogiri::HTML(File.open(canonical_file)))
      end

      it 'assigns found url' do
        story.save!
        expect(story.url).to eq('http://www.example.com/product.php?item=swedish-fish')
      end

      it 'sets scrape_status to pending' do
        expect(story.scrape_status).to eq('Pending')
      end
    end

    context 'when no rel=canonical but og:url exists' do
      before do
        allow(story).to receive(:page).and_return(Nokogiri::HTML(File.open(og_file)))
      end

      it 'assigns found url' do
        story.save!
        expect(story.url).to eq('http://ogp.me/')
      end

      it 'sets scrape_status to pending' do
        expect(story.scrape_status).to eq('Pending')
      end
    end

    context 'when no rel=canonical and og:url' do
      before do
        allow(story).to receive(:page).and_return(Nokogiri::HTML(File.open(no_meta_file)))
      end

      it 'assigns given url' do
        story.save!
        expect(story.url).to eq('http://www.example.com/original')
      end

      it 'sets scrape_status to pending' do
        expect(story.scrape_status).to eq('Pending')
      end
    end
  end
end
