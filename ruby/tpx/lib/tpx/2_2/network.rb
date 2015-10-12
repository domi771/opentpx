require 'tpx/2_2/data_model'

module TPX_2_2

  # A set of defined network membership, routing topology, ownership, and network announcements.
  class Network < DataModel
    MANDATORY_ATTRIBUTES = [
      :occurred_at_t,
      :asn_number_ui # TODO: Add to specification document
    ]

    # Overrides the default initialize to add a default occurred_at_t.
    #
    # @param [Hash] input_hash The input hash.
    #
    # @return [DataModel] The returned object.
    def initialize(input_hash)
      input_hash[:occurred_at_t] ||= Time.now.getutc.to_i  # TODO: Should we do this here?  Should we do this everywhere except ThreatObservable?
      super input_hash
    end

  end
end
