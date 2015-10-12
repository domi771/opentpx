require 'spec_helper_2_1'

describe TPX_2_1::Exchange do
  subject {
    TPX_2_1::Exchange.new(
      provider_s: 'provider',
      source_observable_s: 'source_observable',
      source_description_s: 'source_description',
      distribution_time_t: distribution_time,
      list_name_s: 'list_name',
      element_observable_c_array: [element_observable_0]
    )
  }
  let(:distribution_time) { Time.now.utc.to_i }
  let(:threat_observable_c_map) {
    {
      'Conficker' => {
        'occurred_at_t' => 4355545,
        'last_seen_t' => 13123
      }
    }
  }
  let(:element_observable_0) {
    TPX_2_1::ElementObservable.new(
      subject_ipv4_s: '192.168.0.0',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map
    )
  }
  let(:element_observable_1) {
    TPX_2_1::ElementObservable.new(
      subject_ipv4_s: '192.168.0.1',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map
    )
  }
  let(:element_observable_2) {
    TPX_2_1::ElementObservable.new(
      subject_ipv4_s: '192.168.0.2',
      score_i: 80,
      score_24hr_decay_i: 0,
      threat_observable_c_map: threat_observable_c_map
    )
  }
  let(:collection_element_1) {
    TPX_2_1::CollectionElement.new(
      name_id_s: 'MarketSeg1',
      occurred_at_t: 1212312323,
      last_updated_t: 1212312323,
      description_s: 'This collection is related to MarketSeg1',
      author_s: 'Allan Thomson',
      workspace_s: 'lg-system'
    )
  }
  let(:collection_element_2) {
    TPX_2_1::CollectionElement.new(
      name_id_s: 'MarketSeg2',
      occurred_at_t: 1212312323,
      last_updated_t: 1212312323,
      description_s: 'This collection is related to MarketSeg2',
      author_s: 'Allan Thomson',
      workspace_s: 'lg-system'
    )
  }
  let(:collection_element_3) {
    TPX_2_1::CollectionElement.new(
      name_id_s: 'MarketSeg3',
      occurred_at_t: 1212312323,
      last_updated_t: 1212312323,
      description_s: 'This collection is related to MarketSeg3',
      author_s: 'Allan Thomson',
      workspace_s: 'lg-system'
    )
  }
  let(:collection) {
    TPX_2_1::Collection.new([ collection_element_1, collection_element_2 ])
  }
  let(:network) {
    TPX_2_1::Network.new(
      asn_number_i: 1,
      occurred_at_t: 1212312323,
      as_owner_s: 'ABC Corp'
    )
  }
  let(:observable_definition) {
    TPX_2_1::ObservableDefinition.new(
      observable_id_s: Time.now.utc,
      description_s: 'Something in here',
      classification_c_array: [
        {
          classification_id_s: "APT",
          classification_family_s: "Malware",
          score_i: 70
        }
      ]
    )
  }

  before do
    Timecop.freeze(Time.utc(2015, 8, 6, 12, 0, 0))
  end

  after do
    Timecop.return
  end
  it_behaves_like 'a TPX 2.1 data model'

  describe '#<<' do
    it 'should support multiple input data-types within an array' do
      subject << [element_observable_1, collection_element_1, network]
      expect( subject.element_observable_c_array ).to eq([element_observable_0, element_observable_1])
      expect( subject.collection_c_array ).to eq([collection_element_1])
      expect( subject.asn_c_array ).to eq([network])
    end

    it 'should support adding a collection' do
      subject << collection
      expect( subject.collection_c_array ).to eq(collection)
    end

    it 'should support adding a collection as well as collection_element objects' do
      subject << collection
      expect( subject.collection_c_array ).to eq(collection)
      subject << collection_element_3
      expect( subject.collection_c_array ).to eq(collection << collection_element_3)
    end

    it 'should not add duplicate items to a collection' do
      subject << collection_element_1
      expect( subject.collection_c_array ).to eq([collection_element_1])
      expect{
        subject << collection
      }.to raise_error(
        TPX_2_1::DuplicateElementInsertError,
        'Duplicate input object id MarketSeg1 provided to TPX_2_1::Collection!'
      )
    end
  end

  context "(import methods)" do
    context "when supplied with valid input" do
      let(:valid_tpx_filelist) {Dir.glob(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'data', 'valid*')))}
      let(:valid_tpx_file) {File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'data', 'valid_tpx_file.json'))}
      let(:valid_input_hash) {Oj.load_file(valid_tpx_file)}

      describe ".import" do
        it "should not raise exceptions" do
          expect {TPX_2_1::Exchange.import(valid_input_hash)}.not_to raise_error
        end

        it "should create valid Exchange" do
          exchange = TPX_2_1::Exchange.import(valid_input_hash)
          expect(exchange["element_observable_c_array"].size).to eq valid_input_hash["element_observable_c_array"].size
          expect(exchange["observable_dictionary_c_array"]).to eq valid_input_hash["observable_dictionary_c_array"]
        end
      end

      describe ".import_file" do
        it "should not raise errors" do
          valid_tpx_filelist.each do |f|
            expect {TPX_2_1::Exchange.import_file(f)}.not_to raise_error
          end
        end

        it "should create valid Exchange" do
          exchange = TPX_2_1::Exchange.import_file(valid_tpx_file)
          expect(exchange["element_observable_c_array"].size).to eq valid_input_hash["element_observable_c_array"].size
          expect(exchange["observable_dictionary_c_array"]).to eq valid_input_hash["observable_dictionary_c_array"]
        end
      end
    end

    context "when supplied valid input but with undefined observable dictionary entry" do
      let(:valid_tpx_filelist) {Dir.glob(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'data', 'undefined*')))}
      describe ".import_file" do
        it "should raise exceptions" do
          valid_tpx_filelist.each do |f|
            expect {TPX_2_1::Exchange.import_file(f)}.to raise_error TPX_2_1::ValidationWarning
          end
        end
      end
    end

    context "when supplied with invalid input" do
      let(:invalid_tpx_filelist) {Dir.glob(File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'data', 'invalid*')))}
      describe ".import_file" do
        it "should raise exceptions" do
          invalid_tpx_filelist.each do |f|
            expect {TPX_2_1::Exchange.import_file(f)}.to raise_error TPX_2_1::ValidationError
          end
        end
      end
    end
  end

  describe 'private .split_section' do
    before { subject.instance_variable_set(:@manifest_files_count, 3) }

    it 'should split section correctly' do
      expect(subject.send(:split_section, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])).to eq([[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]])
    end
  end

  describe 'private .split_section with files number less then 1' do
    before { subject.instance_variable_set(:@manifest_files_count, 0.314) }

    it 'should split section correctly if files_number less than 1' do
      expect(subject.send(:split_section, [1, 2, 3])).to eq([[1, 2, 3]])
    end
  end

  describe '#to_manifest' do
    subject {
      TPX_2_1::Exchange.new(
        provider_s: 'provider',
        source_observable_s: 'source_observable',
        source_description_s: 'source_description',
        distribution_time_t: distribution_time,
        list_name_s: 'list_name'
      )
    }

    before { subject.instance_variable_set(:@manifest_files_count, 3) }

    it 'should return correct hash without sub manifest arguments' do
      expect(subject.send(:to_manifest, 'spec/data/test.json')).to eq({
        "schema_version_s"=>"2.1.6",
        "provider_s"=>"provider",
        "list_name_s"=>"list_name",
        "source_observable_s"=>"source_observable",
        "source_description_s"=>"source_description",
        "distribution_time_t"=>distribution_time,
        "last_updated_t"=>distribution_time
      })
    end
  end

  describe '#to_manifest with manifest files' do
    subject {
      TPX_2_1::Exchange.new(
        provider_s: 'provider',
        source_observable_s: 'source_observable',
        source_description_s: 'source_description',
        distribution_time_t: distribution_time,
        list_name_s: 'list_name'
      )
    }

    before { subject.instance_variable_set(:@manifest_files_count, 2) }

    it 'should return correct hash with observable_element_file_manifest' do
      subject << element_observable_1
      subject << element_observable_2

      expect(subject.send(:to_manifest, 'spec/data/test.json')).to eq({
        "schema_version_s" => "2.1.6",
        "provider_s" => "provider",
        "list_name_s" => "list_name",
        "source_observable_s" => "source_observable",
        "source_description_s" => "source_description",
        "distribution_time_t" => distribution_time,
        "last_updated_t" => distribution_time,
        "observable_element_file_manifest" => ["spec/data/20150806120000_data_1.json", "spec/data/20150806120000_data_2.json"],
      })
    end

    it 'should return correct hash with collection_file_manifest' do
      subject << collection

      expect(subject.send(:to_manifest, 'spec/data/test.json')).to eq({
        "schema_version_s" => "2.1.6",
        "provider_s" => "provider",
        "list_name_s" => "list_name",
        "source_observable_s" => "source_observable",
        "source_description_s" => "source_description",
        "distribution_time_t" => distribution_time,
        "last_updated_t" => distribution_time,
        "collection_file_manifest" => ["spec/data/20150806120000_collection_1.json", "spec/data/20150806120000_collection_2.json"]
      })
    end

    it 'should return correct hash with network_file_manifest' do
      subject << network
      expect(subject.send(:to_manifest, 'spec/data/test.json')).to eq({
        "schema_version_s" => "2.1.6",
        "provider_s" => "provider",
        "list_name_s" => "list_name",
        "source_observable_s" => "source_observable",
        "source_description_s" => "source_description",
        "distribution_time_t" => distribution_time,
        "last_updated_t" => distribution_time,
        "asn_file_manifest" => ["spec/data/20150806120000_asn_1.json"]
      })
    end
  end

end
