require 'spec_helper_2_2'

describe TPX_2_2::ThreatObservable do
  subject {
    TPX_2_2::ThreatObservable.new( threat_observable_hash )
  }
  let(:threat_observable_hash) {
    {
      occurred_at_t: Time.now.utc.to_i,
      observable_id_s: observable_id_s,
      description_s: description_s,
      criticality_i: criticality_i,
      score_i: score_i,
      score_24hr_decay_i: score_24hr_decay_i,
      classification_c_array: classification_c_array,
      attribute_c_map: attribute_c_map,
      notes_s: notes_s,
      reference_s_array: reference_s_array,
      summary_s: summary_s
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
  let(:observable_id_s) { 'Conficker A' }
  let(:description_s) { 'If an IP address or domain has been associated with this tag, it means that Intel Provider Company has identified the IP address or domain to be associated with the Conficker botnet variant A.' }
  let(:score_i) { 80 }
  let(:criticality_i) { 70 }
  let(:score_24hr_decay_i) { 2 }
  let(:classification_c_array) { [{'classification_s' => 'Conficker', 'score_i' => 70, 'score_24hr_decay_i' => 2}] }
  let(:notes_s) { 'These are user defined notes providing additional background to the description' }
  let(:reference_s_array) { ['http://www.thisisareference.com/observablereference', 'http://www.anotherreference.com/2ndrefererence'] }
  let(:summary_s) { 'This is a summary of the observable description' }

  it_behaves_like 'a TPX 2.2 data model'

  describe '#initialize' do
    it 'it should add attributes dynamically' do
      expect((subject["fqdn_c_array"] ||= [] )<< { 'fqdn_s' => 'domain.com' }).to eq([{'fqdn_s' => 'domain.com'}])
    end
  end
end
