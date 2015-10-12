require 'spec_helper_2_1'

describe TPX_2_1::ElementObservable do
  subject {
    TPX_2_1::ElementObservable.new( element_observable_hash )
  }

  let(:element_observable_hash) {
    {
      subject_ipv4_s: '192.168.0.1',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map_1
    }
  }
  let(:threat_observable_c_map_1) {
    {
      'Conficker A' => {
        'occurred_at_t' => 4355545,
        'last_seen_t' => 13123,
        'country_code_s' => 'IR',
        'destination_fqdn_s' => 'ddd.com',
        'score_i' => 70,
      },
      'Clicker' => {
        'occurred_at_t' => 4355545,
        'last_seen_t' => 13123
      }
    }
  }
  let(:threat_observable_c_map_2) {
    {
      'Conficker A' => {
        'occurred_at_t' => 0,
        'last_seen_t' => 13123,
        'country_code_s' => 'IR',
        'destination_fqdn_s' => 'ddd.com',
        'score_i' => 70,
      },
      'Clicker' => {
        'occurred_at_t' => 4355545,
        'last_seen_t' => 13123
      }
    }
  }

  it_behaves_like 'a TPX 2.1 data model'

  describe '#initialize' do
    it 'should raise an error on an incorrect type' do
      expect{
        TPX_2_1::ElementObservable.new(subject_badtype_s: '192.168.0.1', threat_observable_c_map: {})
      }.to raise_error(
        TPX_2_1::ValidationError,
        'A member of the mandatory attribute set `[:subject_ipv4_s, :subject_ipv4_i, :subject_ipv6_s, :subject_ipv6_i, :subject_fqdn_s, :subject_cidrv4_s, :subject_cidrv6_s, :subject_asn_s, :subject_asn_i, :subject_md5_h, :subject_sha1_h, :subject_sha256_h, :subject_sha512_h, :subject_registrykey_s, :subject_filename_s, :subject_filepath_s, :subject_mutex_s, :subject_actor_s, :subject_email_s]` is missing from the supplied input_hash paramater to TPX_2_1::ElementObservable.'
      )
    end
  end

end
