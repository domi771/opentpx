require 'deep_merge'
# This uses the TPX JSON Schema to validate an input document.
module TPX_2_2
  class Validator

    class << self
      TPX_KEYS = ['observable_dictionary_c_array', 'element_observable_c_array', 'collection_c_array', 'asn_c_array']
      MANIFEST_KEYS = ['dictionary_file_manifest', 'observable_element_file_manifest', 'collection_file_manifest', 'network_file_manifest']

      # validate_file! opens json file and validates it. Raises an error if validation fails.
      #
      # @param [String] filepath path to file which needs to be validated.
      # @example
      #   TPX_2_2::Validator.validate_file!('folder_name/file_name.json')
      def validate_file!(filepath)
        unless File.exists? filepath
          raise ValidationError , "No such file or directory '#{filepath}'"
        end

        @@current_path = File.dirname(filepath)

        begin
          h = Oj.load_file(filepath)
        rescue => e
          raise ValidationError, "File '#{filepath}' is not a valid JSON file:\n#{e}"
        end

        if h.kind_of?(Hash) and tpx_manifest?(h)
          DeepMerge::deep_merge!(load_manifest_files(h), h, {:merge_hash_arrays => true})
          delete_manifest_keys!(h)
        end

        validate!(h)
      end

      # validate_json! validates json string. Raises an error if validation fails.
      #
      # @param [String] json_enc_str the json string which need to be validated.
      # @example
      #   TPX_2_2::Validator.validate_json!("{\"provider_s\":\"provider\",\"schema_version_s\":\"2.1.6\",\"source_observable_s\":\"source_observable\",\"source_description_s\":\"source_description\",\"distribution_time_t\":1438862400,\"last_updated_t\":1438862400,\"list_name_s\":\"list_name\",\"element_observable_c_array\":[{\"subject_s\":\"192.168.0.1\",\"type_s\":\"ipv4\",\"score_i\":80,\"score_24hr_decay_i\":0,\"threat_observable_c_map\":{\"Conficker\":{\"occurred_at_t\":4355545,\"last_seen_t\":13123}}}],\"observable_dictionary_c_array\":[{\"observable_id_s\":\"Malicious Host\",\"description_s\":\"This network node is a malicious host.\",\"criticality_i\":20,\"classification_c_array\":[{\"classification_id_s\":\"Malicious Host\",\"criticality_i\":20}]}],\"collection_c_array\":[{\"name_id_s\":\"MarketSeg1\",\"occurred_at_t\":1212312323,\"last_updated_t\":1212312323,\"description_s\":\"This collection is related to MarketSeg1\",\"author_s\":\"Allan Thomson\",\"workspace_s\":\"lg-system\"}],\"asn_c_array\":[{\"asn_number_ui\":1,\"occurred_at_t\":1212312323,\"as_owner_s\":\"ABC Corp\"}]}")
      def validate_json!(json_enc_str)
        h = Oj.load(json_enc_str)
        validate!(h)
      end

      # validate! validates hash. Raises an error if validation fails.
      #
      # @param [Hash] input_hash the hash which needs to be validated.
      # @example
      #   TPX_2_2::Validator.validate!({
      #     'provider_s': 'provider',
      #     'schema_version_s': '2.1.6',
      #     'source_observable_s': 'source_observable',
      #     'source_description_s': 'source_description',
      #     'distribution_time_t': 1438862400,
      #     'last_updated_t': 1438862400,
      #     'list_name_s': 'list_name',
      #     'element_observable_c_array': [
      #       {
      #         'subject_s': '192.168.0.1',
      #         'type_s': 'ipv4',
      #         'score_i': 80,
      #         'score_24hr_decay_i': 0,
      #         'threat_observable_c_map': {
      #           'Conficker': {
      #             'occurred_at_t': 4355545,
      #             'last_seen_t': 13123
      #           }
      #         }
      #       }
      #     ],
      #     'observable_dictionary_c_array': [
      #       {
      #         'observable_id_s': 'Malicious Host',
      #         'description_s': 'This network node is a malicious host.',
      #         'criticality_i': 20,
      #         'classification_c_array': [
      #           {
      #             'classification_id_s': 'Malicious Host',
      #             'criticality_i': 20
      #           }
      #         ]
      #       }
      #     ],
      #     'collection_c_array': [
      #       {
      #         'name_id_s': 'MarketSeg1',
      #         'occurred_at_t': 1212312323,
      #         'last_updated_t': 1212312323,
      #         'description_s': 'This collection is related to MarketSeg1',
      #         'author_s': 'Allan Thomson',
      #         'workspace_s': 'lg-system'
      #       }
      #     ],
      #     'asn_c_array': [
      #       {
      #         'asn_number_ui': 1,
      #         'occurred_at_t': 1212312323,
      #         'as_owner_s': 'ABC Corp'
      #       }
      #     ]
      #   })
      def validate!(input_hash)
        @@undefined_observables = []

        if input_hash.nil? || input_hash.empty?
          raise ValidationError, " TPX has no content"
        end

        validate_schema!(input_hash)

        if (TPX_KEYS & input_hash.keys).length > 0 && tpx_manifest?(input_hash)
          raise TPX_2_2::ValidationError, "TPX file must either be in single-file or manifest format."
        end

        validate_element_observables!(input_hash['element_observable_c_array'])
        validate_observable_dictionary!(input_hash['observable_dictionary_c_array'], input_hash['element_observable_c_array'])
        validate_collections!(input_hash['collection_c_array'])
        validate_networks!(input_hash['asn_c_array'])
        if (input_hash['observable_dictionary_c_array'].nil? || input_hash['observable_dictionary_c_array'].empty?)
          raise TPX_2_2::ValidationWarning, "observable dictionary is not defined"
        end
        unless @@undefined_observables.empty?
          raise TPX_2_2::ValidationWarning, "observables #{@@undefined_observables.inspect} are not defined in the observable dictionary"
        end
      end


      private

      def validate_schema!(input_hash)
        errors = JSON::Validator.fully_validate(TPX_2_2::SCHEMA, input_hash)
        raise ValidationError, "#{errors.join(' ')}" unless errors.empty?
      end

      def validate_element_observables!(element_observable_list)
        return if element_observable_list.nil? #nothing to validate, just return

        schema = {
          "type" => "object",
          "required" => ["threat_observable_c_map"],
          "properties" => {
            "threat_observable_c_map" => {"type" => "hash"}
          }
        }
        element_observable_list.each do |element_observable|
          errors = JSON::Validator.fully_validate(schema, element_observable)
          raise ValidationError, "#{errors.join(' ')}" unless errors.empty?
        end
      end

      def validate_observable_dictionary!(observable_dictionaries, element_observable_list)
        return if observable_dictionaries.nil? #nothing to validate, just return

        schema = {
          "type" => "object",
          "required" => [
            "observable_id_s",
            "description_s",
            "classification_c_array"
          ],
          "properties" => {
            "observable_id_s" => {"type" => "string"},
            "description_s" => {"type" => "string"},
            "classification_c_array" => {"type" => "hash"}
          }
        }

        observables = []

        observable_dictionaries.each do |observable_dictionary|
          errors = JSON::Validator.fully_validate(schema, observable_dictionary)
          raise TPX_2_2::ValidationError, "#{errors.join(' ')}" unless errors.empty?
          observables << observable_dictionary['observable_id_s']
        end

        return if element_observable_list.nil?
        element_observable_list.each do |element_observable|
          element = element_observable['threat_observable_c_map'] || element_observable[:threat_observable_c_map]
          element.each_key do |observable|
            @@undefined_observables << """#{observable}""" unless observables.include? observable
          end
        end

      end

      def validate_collections!(collections)
        return if collections.nil? #nothing to validate, just return

        schema = {
          "type" => "object",
          "required" => ["name_id_s"],
          "properties" => {
            "name_id_s" => {"type" => "string"}
          }
        }

        collections.each do |collection|
          errors = JSON::Validator.fully_validate(schema, collection)
          raise ValidationError, "#{errors.join(' ')}" unless errors.empty?
          collection.each do |key, value|
            if (key == 'collection_c_array') && value.is_a?(Array)
              validate_collections!(value)
            end
          end
        end
      end

      def validate_networks!(networks)
        return if networks.nil? #nothing to validate, just return

        schema = {
          "type" => "object",
          "required" => ["asn_number_ui"],
          "properties" => {
            "asn_number_ui" => {"type" => "integer"}
          }
        }

        networks.each do |net|
          errors = JSON::Validator.fully_validate(schema, net)
          raise ValidationError, "#{errors.join(' ')}" unless errors.empty?
        end
      end

      # tpx_manifest? returns true if provided hash represents TPX manifest and contains TPX manifest entries
      #
      # @param [Hash] Hash with tpx content
      # @example
      #   TPX_2_2::Validator.tpx_manifest?({   "schema_version_s"=> "2.2.0",  "provider_s"=> "Lookingglass Cyber Solutions",  "list_name_s"=> "Virus Tracker",   "source_observable_s"=> "Virus Tracker",   "source_file_s"=> "https://virustracker.net/",  "source_description_s"=> "Virus Tracker provides real-time information about virus infections observed through custom sinkholes.",   "distribution_time_t"=> 1443007504,  "last_updated_t"=> 1443007504,   "score_i"=> 90,   "dictionary_file_manifest"=> [  "dictionary.json"  ],   "observable_element_file_manifest"=> [  "data8.json"  ]})
      def tpx_manifest?(input_hash)
        (MANIFEST_KEYS & input_hash.keys).length > 0
      end

      # current_path returns the current path which can be one of: 1) current working directory 2) file directory path being validated
      def current_path
        @@current_path || Dir.pwd
      end

      # load_manifest_files loads files referenced in manifests and returns merged content
      #
      # @param [Hash] Hash with tpx content
      def load_manifest_files(input_hash)
        res = {}
        MANIFEST_KEYS.each do |manifest_section|
          files = input_hash[manifest_section]
          unless files.blank?
            files.each do |manifest_file|
              DeepMerge::deep_merge!(load_manifest_file(manifest_file), res, {:merge_hash_arrays => true})
            end
          end
        end
        res
      end

      # delete_manifest_keys! deletes manifest keys from input_hash in order to be valid TPX
      #
      # @param [Hash] Hash with tpx content
      def delete_manifest_keys!(input_hash)
        MANIFEST_KEYS.each do |key|
          input_hash.delete key
        end
      end

      # load_manifest_file loads TPX content from specified file, in case if file doesn't exists searches for it in current_path. In case if file not found ValidationError is raised
      #
      # @param [String] filename
      def load_manifest_file(filename)
        return Oj.load_file(filename) if File.exists? filename

        filepath = File.join(current_path, File.basename(filename))
        return Oj.load_file(filepath) if File.exists? filepath

        raise ValidationError, "Could not find #{filename}"
      end

    end # class < self
  end
end
