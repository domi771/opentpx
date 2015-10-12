require 'spec_helper_2_1'

describe TPX_2_1::ObservableDictionary do
  subject {
    TPX_2_1::ObservableDictionary.new( [ observable_def_1 ] )
  }

  let(:observable_def_1) {
    TPX_2_1::ObservableDefinition.new(observable_def_hash_1)
  }
  let(:observable_def_2) {
    TPX_2_1::ObservableDefinition.new(observable_def_hash_2)
  }

  let(:observable_def_hash_1) {
    {
      'occurred_at_t' => Time.now.utc.to_i,
      'observable_id_s' => 'Conficker A',
      'description_s' => description_s,
      'criticality_i' => criticality_i,
      'score_i' => score_i,
      'score_i_24hr_decay_i' => score_24hr_decay_i,
      'classification_c_array' => classification_c_array,
      'attribute_c_map' => attribute_c_map
    }
  }

  let(:observable_def_hash_2) {
    {
      'occurred_at_t' => Time.now.utc.to_i,
      'observable_id_s' => 'Clicker',
      'description_s' => description_s,
      'criticality_i' => criticality_i,
      'score_i' => score_i,
      'score_24hr_decay_i' => score_24hr_decay_i,
      'classification_c_array' => classification_c_array,
      'attribute_c_map' => attribute_c_map
    }
  }

  let(:attribute_c_map) {
    {
      'analysis_last_updated_t' => 1421700366,
      'hash_md5_h' => '5013a954e6793d3610df43e761fd2deacdd3cd81dbc0ef902c5756bca61b5a94',
      'priority_i' => 0,
      'submission_last_updated_t' => 1421700366,
      'tlp_i' => 1
    }
  }

  let(:description_s) { 'If an IP address or domain has been associated with this tag, it means that Intel Provider Company has identified the IP address or domain to be associated with the Conficker botnet variant A.' }
  let(:score_i) { 80 }
  let(:criticality_i) { 70 }
  let(:score_24hr_decay_i) { 2 }
  let(:classification_c_array) {
    [
      {
        'classification_s' => 'Conficker',
        'score_i' => 70,
        'score_24hr_decay_i' => 2
      }
    ]
  }

  it_behaves_like 'a homogeneous list of data models'
end
