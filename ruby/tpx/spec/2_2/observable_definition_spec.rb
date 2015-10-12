require 'spec_helper_2_2'

describe TPX_2_2::ObservableDefinition do
  subject {
    TPX_2_2::ObservableDefinition.new(
      observable_id_s: Time.now.utc,
      description_s: 'Something in here',
      classification_c_array: [classification_1]
    )
  }

  let(:classification_1) {
    {
      classification_id_s: "APT",
      classification_family_s: "Malware",
      score_i: 70
    }
  }

  it_behaves_like 'a TPX 2.2 data model'
end
