require 'tpx/2_2/exceptions'
require 'tpx/2_2/mandatory_attributes'
require 'tpx/2_2/attribute_accessors'

module TPX_2_2

  # The base class for a TPX dictionary/hash.
  class DataModel < ::HashWithIndifferentAccess
    include AttributeAccessors
    include MandatoryAttributes

    # Overrides the default initialize to validate the input data.
    #
    # @param input_hash [Hash] The input hash.
    #
    # @return [DataModel] The returned object.
    def initialize(input_hash)
      unless input_hash.is_a? Hash
        raise ValidationError, "Parameter `input_hash` supplied to #{self.class} must be of type Hash (#{input_hash.class}: #{input_hash.inspect})!"
      end
      super input_hash
      validate!
    end

    # Overrides the default to_h method to return a hash with symbolized keys.
    #
    # @return [Object] The returned hash.
    def to_h
      self.symbolize_keys.to_h
    end
  end
end
