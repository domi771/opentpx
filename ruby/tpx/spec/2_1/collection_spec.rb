require 'spec_helper_2_1'

describe TPX_2_1::Collection do
  subject {
    TPX_2_1::Collection.new( [collection_element_1] )
  }
  let(:collection_2) {
    TPX_2_1::Collection.new( [collection_element_1, collection_element_2] )
  }
  let(:collection_element_1) {
    TPX_2_1::CollectionElement.new( collection_hash_1 )
  }
  let(:collection_element_2) {
    TPX_2_1::CollectionElement.new( collection_hash_2 )
  }
  let(:collection_hash_1) {
    {
      name_id_s: 'MarketSeg1',
      occurred_at_t: 1212312323,
      last_updated_t: 1212312323,
      description_s: 'This collection is related to MarketSeg1',
      author_s: 'Allan Thomson',
      workspace_s: 'lg-system'
    }
  }
  let(:collection_hash_2) {
    {
      name_id_s: 'AnotherCollection',
      occurred_at_t: 1212312323,
      last_updated_t: 1212312323,
      description_s: 'This collection is another collection',
      author_s: 'Allan Thomson',
      workspace_s: 'lg-system'
    }
  }

  it_behaves_like 'a homogeneous list of data models'

  describe '#initialize' do
    it 'should create a new object when supplied valid input' do
      expect(subject.first.name_id_s).to eq('MarketSeg1')
      expect(subject.first.occurred_at_t).to eq(1212312323)
      expect(subject.first.last_updated_t).to eq(1212312323)
      expect(subject.first.description_s).to eq('This collection is related to MarketSeg1')
      expect(subject.first.author_s).to eq('Allan Thomson')
      expect(subject.first.workspace_s).to eq('lg-system')
    end

    it 'should only allow CollectionElement objects' do
      expect{
        TPX_2_1::Collection.new([1])
      }.to raise_error(
        TPX_2_1::ValidationError, 'Supplied input object 1 at position 0 not of required type TPX_2_1::CollectionElement in TPX_2_1::Collection!'
      )
    end
  end

  describe '#<<' do
    it 'should accept new elements' do
      expect(subject).to eq( [collection_element_1] )
      subject << collection_element_2
      expect(subject).to eq( [collection_element_1, collection_element_2] )
    end
  end

  describe '#==' do
    before do
      subject << collection_element_2
    end

    it 'should equate collections' do
      expect( subject == collection_2 ).to be true
    end
  end
end
