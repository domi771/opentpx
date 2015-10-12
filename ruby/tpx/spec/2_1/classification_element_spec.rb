require 'spec_helper_2_1'

describe TPX_2_1::ClassificationElement do
  subject {
    classification_element_1
  }

  let(:classification_element_1) {
    TPX_2_1::ClassificationElement.new(classification_element_hash_1)
  }

  let(:classification_element_hash_1) {
    {
      classification_id_s: 'Conficker A',
      classification_family_s: 'Botnet',
      score_i: 60,
    }
  }

  it_behaves_like 'a TPX 2.1 data model'

end
