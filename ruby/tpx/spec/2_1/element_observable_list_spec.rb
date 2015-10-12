require 'spec_helper_2_1'

describe TPX_2_1::ElementObservableList do
  subject { TPX_2_1::ElementObservableList.new(elements) }

  let(:elements) { [element_observable_1, element_observable_2] }
  let(:element_observable_1) { TPX_2_1::ElementObservable.new(element_observable_hash_1) }
  let(:element_observable_2) { TPX_2_1::ElementObservable.new(element_observable_hash_2) }
  let(:element_observable_3) { TPX_2_1::ElementObservable.new(element_observable_hash_3) }
  let(:element_observable_4) { TPX_2_1::ElementObservable.new(element_observable_hash_4) }
  let(:element_observable_hash_1) {
    {
      subject_ipv4_s: '192.168.0.1',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map
    }
  }
  let(:element_observable_hash_2) {
    {
      subject_ipv4_s: '192.168.0.2',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map
    }
  }
  let(:element_observable_hash_3) {
    {
      subject_ipv4_s: '192.168.0.1',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map_2
    }
  }
  let(:element_observable_hash_4) {
    {
      subject_ipv4_s: '192.168.0.3',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map
    }
  }
  let(:threat_observable_c_map) {
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
      'Malware' => {
        'occurred_at_t' => 4355545,
        'last_seen_t' => 13123,
        'country_code_s' => 'UA',
        'destination_fqdn_s' => 'site.com',
        'score_i' => 70,
      }
    }
  }

  it_behaves_like 'a merging heterogeneous list of data models'

  describe '#initialize' do
    it 'should create a new list given valid input' do
      expect(subject.length).to eq(2)
      expect(subject[0]['subject_ipv4_s']).to eq('192.168.0.1')
      expect(subject[1]['subject_ipv4_s']).to eq('192.168.0.2')
    end
    it 'should warn on duplicate input elements' do
      expect{
        TPX_2_1::ElementObservableList.new([element_observable_1, element_observable_1])
      }.to raise_error(
        TPX_2_1::DuplicateElementInsertError
      )
    end
    it 'should ensure all items are the proper type' do
      expect{
        TPX_2_1::ElementObservableList.new({foo: 'bar'})
      }.to raise_error(
        TPX_2_1::ValidationError
      )
    end
  end

  describe '#<<' do
    it 'should ensure all items are the proper type' do
      expect{subject << {foo: 'bar'}}.to raise_error(TPX_2_1::ValidationError)
    end
    it 'should add a new element' do
      expect{subject << element_observable_4}.to_not raise_error
      expect(subject.length).to eq(3)
    end
  end

  describe '#<< of an ElementObservable already contained in the ElementObservableList' do
    before { subject << element_observable_3 }
    it 'should insert and merge the ThreatObservable children within the existing ElementObservable' do
      expect(subject.length).to eq(2)
      expect(subject[0]['threat_observable_c_map'].length).to eq(3)
      expect(subject[0]['threat_observable_c_map'].has_key? 'Malware').to be(true)
    end
  end

end
