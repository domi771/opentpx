require 'spec_helper_2_1'
require 'json'

describe TPX_2_1::Validator do

  let(:element_observable) {
    {
      subject_ipv4_s: '192.168.0.1',
      type_s: 'ipv4' ,
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable
    }
  }

  let(:collection) {
    {
      name_id_s: 'MarketSeg1',
      occurred_at_t: 1212312323,
      last_updated_t: 1212312323,
      description_s: 'This collection is related to MarketSeg1',
      author_s: 'Allan Thomson',
      workspace_s: 'lg-system',
      collection_c_array: [
        {
          name_id_s: 'MarketSeg2',
          occurred_at_t: 1212312323,
          last_updated_t: 1212312323,
          description_s: 'This collection is related to MarketSeg2',
          author_s: 'Allan Thomson',
          workspace_s: 'lg-system',
          fqdn_s_array: [
            "example.com",
            "somexample.com"
          ]
        }
      ]
    }
  }

  let(:network) {
    {
      asn_i: 1,
      occurred_at_t: 1212312323,
      as_owner_s: 'ABC Corp'
    }
  }

  let(:distribution_time) { Time.now.utc.to_i }

  let(:threat_observable) {
    {
      'Malicious Host' => {
        'occurred_at_t' => 4355545,
        'last_seen_t' => 13123
      }
    }
  }

  let(:observable_dictionary) {
    {
      "observable_id_s" => "Malicious Host",
      "description_s" => "This network node is a malicious host.",
      "criticality_i" => 20,
      "classification_c_array" => [
        {
          "classification_id_s" => "Malicious Host",
          "score_i" => 20
        }
      ]
    }
  }

  let(:schema) {
    {
      'provider_s' => 'provider',
      'schema_version_s' => '2.1.6',
      'source_observable_s' => 'source_observable',
      'source_description_s' => 'source_description',
      'distribution_time_t' => distribution_time,
      'last_updated_t' => distribution_time,
      'list_name_s' => 'list_name',
      'element_observable_c_array' => [element_observable],
      'observable_dictionary_c_array' => [observable_dictionary],
      'collection_c_array' => [collection],
      'asn_c_array' => [network]
    }
  }

  before do
    Timecop.freeze(Time.utc(2015, 8, 6, 12, 0, 0))
  end

  after do
    Timecop.return
  end

  describe '##validate_schema!' do
    it 'should not raise error when supplied with valid TPX' do
      expect{TPX_2_1::Validator.send(:validate_schema!, schema )}.to_not raise_error
    end
    it 'should raise error when supplied with invalid TPX' do
      s = schema.dup.delete('provider_s')
      expect{TPX_2_1::Validator.send(:validate_schema!, s )}.to raise_error(TPX_2_1::ValidationError)
    end
  end

  describe '##validate_collections!' do
    it 'should validate collections' do
      expect(TPX_2_1::Validator.send(:validate_collections!, [collection])).to eq([collection])
    end
    it 'should raise error when supplied with invalid collection' do
      collection.delete(:name_id_s)
      expect{TPX_2_1::Validator.send(:validate_collections!, [collection])}.to raise_error(TPX_2_1::ValidationError, /The property \'#\/\' did not contain a required property of \'name_id_s\' in schema /)
    end
  end

  describe '##validate_element_observables!' do
    it 'should validate element observables' do
      expect(TPX_2_1::Validator.send(:validate_element_observables!, [element_observable])).to eq([element_observable])
    end
    it 'should raise error when supplied with invalid element observable' do
      element_observable.delete(:threat_observable_c_map)
      expect{TPX_2_1::Validator.send(:validate_element_observables!, [element_observable])}.to raise_error(TPX_2_1::ValidationError, /The property \'#\/\' did not contain a required property of \'threat_observable_c_map\' in schema /)
    end
  end

  describe '##validate_networks!' do
    it 'should validate networks' do
      expect(TPX_2_1::Validator.send(:validate_networks!, [network])).to eq([network])
    end
    it 'should raise error when supplied with invalid networks' do
      network.delete(:asn_i)
      expect{TPX_2_1::Validator.send(:validate_networks!, [network])}.to raise_error(TPX_2_1::ValidationError, /The property \'#\/\' did not contain a required property of \'asn_i\' in schema /)
    end
  end

  describe '##validate_observable_dictionary!' do
    it 'should not raise error when supplied with valid observable dictionary' do
      expect{TPX_2_1::Validator.send(:validate_observable_dictionary!, [observable_dictionary], [element_observable])}.to_not raise_error
    end
    it 'should raise error when supplied with invalid observable dictionary' do
      observable_dictionary.delete('classification_c_array')
      expect{TPX_2_1::Validator.send(:validate_observable_dictionary!, [observable_dictionary], [element_observable])}.to raise_error(TPX_2_1::ValidationError, /The property \'#\/\' did not contain a required property of \'classification_c_array\' in schema/)
    end
  end


  context 'when supplied with valid input' do
    describe '##validate_json!' do
      it 'should not raise error' do
        expect{TPX_2_1::Validator.validate_json!(schema.to_json)}.to_not raise_error
      end
    end

    describe '##validate!' do
      it 'should not raise error' do
        expect{TPX_2_1::Validator.validate!(schema)}.to_not raise_error
      end
    end

    it 'should not raise error' do
      file = Tempfile.new('TPX::Validator')
      file.write(schema.to_json)
      file.rewind
      expect{TPX_2_1::Validator.validate_file!(file.path)}.to_not raise_error
    end

    context 'when observable has no corresponding entry in the observable dictionary' do
      describe '##validate_file!' do
        let(:file_to_validate) {File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'validator_data', 'undefined_observable_dictionary_entry.json'))}
        it 'should raise exceptions' do
          expect {TPX_2_1::Validator.validate_file!(file_to_validate)}.to raise_error TPX_2_1::ValidationWarning
        end
      end
    end

    context 'with undefined observable dictionary' do
      describe '##validate_file!' do
        let(:file_to_validate) {File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'validator_data', 'undefined_observable_dictionary.json'))}
        it 'should raise exceptions' do
          expect {TPX_2_1::Validator.validate_file!(file_to_validate)}.to raise_error TPX_2_1::ValidationWarning
        end
      end
    end


  end

  context 'when supplied with invalid input' do
    describe '##validate_file!' do
      let(:invalid_validator_filelist) {Dir.glob(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'validator_data', 'invalid*')))}
      it 'should raise exceptions' do
        invalid_validator_filelist.each do |f|
          expect {TPX_2_1::Validator.validate_file!(f)}.to raise_error TPX_2_1::ValidationError
        end
      end
    end
  end
end
