def create_file(text)
  file = Tempfile.new(Time.now.to_i.to_s)
  file.write(text)
  file.close
  file.path
end

shared_examples "a validator" do
  let(:quiet){ '' }
  let(:version){ '' }
  let(:args){ '' }

  before(:each) do
    #@output needs to contain stdout AND stderr
    @output = `#{command}`
  end

  context 'when given an invalid version' do
    let(:args){ 'some_file.json' }
    let(:version){ '-v 9000' }
    it 'should return invalid version error' do
      expect(@output).to match(TPX::Tools::TPX_VERSION_UNKNOWN)
    end
  end

  context 'with version option 2.2' do
    let(:version){ '-v 2.2' }

    context 'when given an empty file' do
      let(:empty_file_path){ create_file('') }
      let(:args){ empty_file_path }
      it 'should return invalid file error' do
        expect(@output).to match(/TPX file provided is invalid/)
        expect(@output).to match('TPX has no content')
      end
    end

    context 'when not given a file' do
      let(:args){ 'not_a_path_to_a_file' }
      it 'should return invalid file error' do
        expect(@output).to match(/TPX file provided is invalid/)
        expect(@output).to match(/No such file or directory/)
      end
    end

    context 'when given an invalid tpx 2.2 file' do
      let(:invalid_tpx_filepath){ create_file(invalid_tpx_2_2_data) }
      let(:args){ invalid_tpx_filepath }
      let(:invalid_tpx_2_2_data) do
        <<JSON
{
  "invalid_key":"value"
}
JSON

      end

      it 'should return invalid file error' do
        # NOTE - the JSON-schema libs from Python and Ruby have different exception message warnings.
        # Ruby command error formats:
        if command.match(/^ruby/)
          expect(@output).to match(/is invalid/)
          expect(@output).to match(/did not contain a required property of 'schema_version_s' in schema/)
          expect(@output).to match(/did not contain a required property of 'provider_s' in schema/)
          expect(@output).to match(/did not contain a required property of 'source_observable_s' in schema/)
          expect(@output).to match(/did not contain a required property of 'last_updated_t' in schema/)
          expect(@output).to match(/did not contain a required property of 'list_name_s' in schema/)
        # Python command error formats:
        elsif command.match(/^python/)
          expect(@output).to match(/Error\(s\) in schema validation/)
          expect(@output).to match(/u'schema_version_s' is a required property/)
          expect(@output).to match(/u'provider_s' is a required property/)
          expect(@output).to match(/u'source_observable_s' is a required property/)
          expect(@output).to match(/u'last_updated_t' is a required property/)
          expect(@output).to match(/u'list_name_s' is a required property/)
        else
          raise "Unexpected command passed to shared validator examples"
        end
      end
    end

    context 'when given a valid tpx 2.2 file' do
      let(:valid_tpx_filepath){ create_file(valid_tpx_2_2_data) }
      let(:args){ valid_tpx_filepath }
      let(:valid_tpx_2_2_data) do
        <<JSON
{
  "schema_version_s":"2.1.5",
  "provider_s":"testprovider.com",
  "list_name_s":"Test List Name",
  "source_observable_s":"TestSource",
  "source_description_s":"TestSource Description",
  "distribution_time_t":1427889602,
  "last_updated_t":1427889602,
  "observable_dictionary_c_array":[
    {
      "observable_id_s":"Malicious Host",
      "description_s":"This network node is a malicious host.",
      "criticality_i":20,
      "classification_c_array":[
        {
          "classification_id_s":"Malicious Host",
          "score_i":20
        }
      ]
    }
  ],
  "element_observable_c_array":[
    {
      "subject_ipv4_s":"202.116.65.35",
      "threat_observable_c_map":{
        "Malicious Host":{
          "occurred_at_t":1435594800,
          "url_s":"lifescience.sysu.edu.cn/filees/guuu16pesche.asp",
          "server_s":"lifescience.sysu.edu.cn.",
          "threat_type_s":"Leads to exploit",
          "contact_s":"-",
          "asn_s":"4538"
        }
      }
    }
  ]
}
JSON
      end
      it 'should return valid file message' do
        expect(@output).to match(/Validation succeeded/)
      end
    end

    context 'when given a valid tpx 2.2 file without a matching dictionary' do
      let(:valid_tpx_filepath){ create_file(valid_tpx_2_2_data) }
      let(:args){ valid_tpx_filepath }
      let(:valid_tpx_2_2_data) do
        <<JSON
{
  "schema_version_s":"2.1.5",
  "provider_s":"testprovider.com",
  "list_name_s":"Test List Name",
  "source_observable_s":"TestSource",
  "source_description_s":"TestSource Description",
  "distribution_time_t":1427889602,
  "last_updated_t":1427889602,
  "observable_dictionary_c_array":[
    {
      "observable_id_s":"Non-matching Observable",
      "description_s":"This intentionally doesn't match any elements",
      "criticality_i":20,
      "classification_c_array":[
        {
          "classification_id_s":"Non-matching Observable",
          "score_i":20
        }
      ]
    }
  ],
  "element_observable_c_array":[
    {
      "subject_ipv4_s":"202.116.65.35",
      "threat_observable_c_map":{
        "Malicious Host":{
          "occurred_at_t":1435594800,
          "url_s":"lifescience.sysu.edu.cn/filees/guuu16pesche.asp",
          "server_s":"lifescience.sysu.edu.cn.",
          "threat_type_s":"Leads to exploit",
          "contact_s":"-",
          "asn_s":"4538"
        }
      }
    }
  ]
}
JSON
      end
      it 'should return valid file message' do
        expect(@output).to match(/Validation succeeded/)
      end

      it 'should output warnings' do
        expect(@output).to match(/Warning.*Malicious Host.*not defined in the observable dictionary/)
      end

      context 'when quiet option given' do
        let(:quiet){ '-q' }

        it 'should return valid file message' do
          expect(@output).to match(/Validation succeeded/)
        end

        it 'should not output warnings' do
          expect(@output).to_not match(/Warning/)
        end
      end
    end
  end
end
