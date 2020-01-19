require File.expand_path '../../spec_helper.rb', __FILE__

describe CanonicalUrlRetriever do
  let(:canonical_file) { File.expand_path '../../support/html/canonical.html', __FILE__  }
  let(:og_file) { File.expand_path '../../support/html/og.html', __FILE__  }
  let(:no_meta_file) { File.expand_path '../../support/html/no_meta.html', __FILE__  }

  describe '.call' do
    context 'when url contains rel=canonical' do
      before do
        allow_any_instance_of(described_class).to receive(:page).and_return(Nokogiri::HTML(File.open(canonical_file)))
      end

      it 'assigns found url' do
        expect(described_class.call('http://example.com')).to eq('http://www.example.com/product.php?item=swedish-fish')
      end
    end

    context 'when no rel=canonical but og:url exists' do
      before do
        allow_any_instance_of(described_class).to receive(:page).and_return(Nokogiri::HTML(File.open(og_file)))
      end

      it 'assigns found url' do
        expect(described_class.call('http://example.com')).to eq('http://ogp.me/')
      end
    end

    context 'when no rel=canonical and og:url' do
      before do
        allow_any_instance_of(described_class).to receive(:page).and_return(Nokogiri::HTML(File.open(no_meta_file)))
      end

      it 'assigns given url' do
        expect(described_class.call('http://www.example.com')).to eq('http://www.example.com')
      end
    end
  end
end
