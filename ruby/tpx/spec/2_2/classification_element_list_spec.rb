require 'spec_helper_2_2'

describe TPX_2_2::ClassificationElementList do
  subject { TPX_2_2::ClassificationElementList.new(classification_elements) }

  let(:classification_elements) { [classification_element_1, classification_element_2] }
  let(:classification_element_1) {
    TPX_2_2::ClassificationElement.new(classification_element_hash_1)
  }
  let(:classification_element_2) {
    TPX_2_2::ClassificationElement.new(classification_element_hash_2)
  }
  let(:classification_element_3) {
    TPX_2_2::ClassificationElement.new(classification_element_hash_3)
  }
  let(:classification_element_hash_1) {
    {
      classification_id_s: 'Conficker A',
      classification_family_s: 'Botnet',
      score_i: 60,
    }
  }
  let(:classification_element_hash_2) {
    {
      classification_id_s: 'Conficker B',
      classification_family_s: 'Botnet',
      score_i: 60,

    }
  }
  let(:classification_element_hash_3) {
    {
      classification_id_s: 'Superbad Malware',
      classification_family_s: 'Botnet',
      score_i: 90
    }
  }

  it_behaves_like 'a homogeneous list of data models'

end
