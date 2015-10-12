require 'tpx/2_1/validator'
require 'tpx/2_1/data_model'
require 'tpx/2_1/observable_dictionary'
require 'tpx/2_1/element_observable_list'
require 'tpx/2_1/network_list'
require 'tpx/2_1/collection'

module TPX_2_1

  # An object representing a TPX file, holding all associated data.
  class Exchange < DataModel

    DEFAULT_MAX_FILESIZE = 1024*1024*1024

    ELEMENT_LISTS = {
      observable_dictionary_c_array: [ObservableDictionary, ObservableDefinition, :dictionary_file_manifest, 'data_dictionary'],
      element_observable_c_array: [ElementObservableList, ElementObservable, :observable_element_file_manifest, 'data'],
      asn_c_array: [NetworkList, Network, :asn_file_manifest, 'asn'],
      collection_c_array: [Collection, CollectionElement, :collection_file_manifest, 'collection']
    }

    MANDATORY_ATTRIBUTES = [
      :schema_version_s,
      :provider_s,
      :source_observable_s,
      :last_updated_t,
      :list_name_s
    ]

    class << self
      # Initialize a TPX_2_1::Exchange from a given filename.
      #
      # @param [String] filename The filename containing the exchange.  This does not call Validator.validate!
      def init_file(filename)
        h = Oj.load_file(filename)
        self.new(h)
      end

      # Imports a tpx file from a given filename.
      #
      # @param [String] filename The filename to import.
      def import_file(filename)
        h = Oj.load_file(filename)
        import(h)
      end

      # Imports a tpx file from a given json string.
      #
      # @param [String] str The string of json to import.
      def import_s(str)
        h = Oj.load(str)
        import(h)
      end

      # Imports a tpx file from a given hash.
      #
      # @param [Hash] input_hash The hash to import.
      def import(input_hash)
        Validator.validate!(input_hash)
        self.new(input_hash)
      end
    end

    # Overrides the default initialize to validate the input data.
    #
    # @param [Hash] input_hash The input hash.
    #
    # @return [DataModel] The returned object.
    def initialize(input_hash)
      input_hash = ::HashWithIndifferentAccess.new(input_hash)
      input_hash[:schema_version_s] = TPX_2_1::CURRENT_SCHEMA_VERSION
      input_hash[:last_updated_t] ||= Time.now.utc.to_i
      input_hash[:observable_dictionary_c_array] ||= []
      input_hash[:source_description_s] ||= ''

      has_one_list = false
      ELEMENT_LISTS.keys.each do |list_key|
        has_list = false
        has_manifest = false
        if input_hash.has_key?(list_key) && input_hash.has_key?(ELEMENT_LISTS[list_key][2])
          raise ValidationError, "Only one of #{list_key} or #{ELEMENT_LISTS[list_key][2]} should be supplied to #{self.class}#initialize input_hash."
        elsif input_hash.has_key?(list_key)
          has_one_list = true
          input_hash[list_key] = ELEMENT_LISTS[list_key][0].new(input_hash[list_key])
        elsif input_hash.has_key?(ELEMENT_LISTS[list_key][2])
          has_one_list = true
        end
      end

      unless has_one_list
        raise ValidationError, "At list one list element (#{ELEMENT_LISTS.keys}) should be supplied to #{self.class}#initialize."
      end

      super input_hash
    end

    # Overrides default << method to add data to the exchange. Checks
    # that added elements are of the correct class.
    #
    # @param element [Object] Element to add to the exchange.
    #
    # @return [Object] The updated Exchange.
    def <<(element)
      if element.is_a? Array
        element.each do |e|
          self << e
        end
        return self
      end

      element_type_supported = false

      ELEMENT_LISTS.each do |list_key, list_def|
        list_type, list_element, list_manifest_key, list_manifest_file_type = *list_def
        if element.class == list_element
          self[list_key] ||= list_type.new([])
          self[list_key] << element
          element_type_supported = true
        end
      end

      unless element_type_supported
        raise ValidationError, "Element provided to #{self.class}#<< has invalid object type (#{element.class})!"
      end

      return self
    end

    # Returns the exchange with empty elements deleted.
    #
    # @param [Hash] h The hash from which to scrub empty elements.
    #
    # @return [Object] The hash with deleted empty elements.
    def _to_h_scrub(h)
      h_scrub = h.dup
      [:observable_dictionary_c_array, :element_observable_c_array, :asn_c_array, :collection_c_array].each do |key|
        h_scrub.delete(key) if h_scrub.has_key? key && h_scrub[key].blank?
      end
      return h_scrub
    end

    # Alias for _to_h_scrub.
    def to_h
      _to_h_scrub(super)
    end

    # Alias for _to_h_scrub.
    def to_hash
      _to_h_scrub(super)
    end

    # Exports the current exchange to a tpx file.
    #
    # @param [String] filepath The file to be exported.
    # @param [Hash] options Additional options to be passed to the json exporter.
    def to_tpx_file(filepath, options={})
      data = (manifest_files_count > 1) ? self.to_manifest(filepath) : self
      Oj.to_file(filepath, data, options.merge({mode: :compat}))
      @manifest_files_count = nil
    end


    private

    def enumerable?(container)
      container.respond_to? :each
    end

    def serializable?(element)
      element.respond_to? :to_hash
    end

    def manifest_files_count
      @manifest_files_count ||= estimated_tpx_file_size / DEFAULT_MAX_FILESIZE
    end

    def estimated_tpx_file_size
      Oj.dump(self).size
    end

    def split_section(section)
      split_count = section.size / manifest_files_count
      section.each_slice(split_count > 1 ? split_count : 1).to_a
    end

    def to_manifest_section(exchange_section, manifest_file_type, path)
      subsections = split_section(exchange_section)
      files = []

      subsections.each_with_index do |item, index|
        # save subsection as TPX file
        files << "#{path}/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_#{manifest_file_type}_#{index + 1}.json"
        Oj.to_file(files.last, item)
      end
     files
    end

    def to_manifest(manifest_file_path)
      exchange_hash = self.to_hash
      manifest_hash = {}

      keys = ['observable_dictionary_c_array', 'element_observable_c_array', 'asn_c_array', 'collection_c_array']
      path = File.dirname(manifest_file_path)

      exchange_hash.each do |key, val|
        manifest_hash[key] = val unless keys.include?(key)
      end

      ELEMENT_LISTS.each do |list_key, list_def|
        list_type, list_element, list_manifest_key, list_manifest_file_type = *list_def
        if exchange_hash.has_key? list_key.to_s
          manifest_hash[list_manifest_key.to_s] = to_manifest_section(exchange_hash[list_key.to_s], list_manifest_file_type.to_s, path) unless exchange_hash[list_key.to_s].empty?
        end
      end

      manifest_hash
    end

  end # class Exchange
end # module TPX_2_1
