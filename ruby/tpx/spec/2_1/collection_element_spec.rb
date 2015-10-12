require 'spec_helper_2_1'

describe TPX_2_1::Collection do
  subject {
    TPX_2_1::CollectionElement.new(
      collection_hash_1
    )
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

  it_behaves_like 'a TPX 2.1 data model'

end
