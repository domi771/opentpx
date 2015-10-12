module TPX_2_1
  module AttributeAccessors

    # Overrides default method_missing to alias method names to hash keys.
    #
    # @param [String] meth The name of the called method.
    # @param [Array<Symbol>] args Additional arguments.
    # @param [Proc] block Additional block.
    #
    # @raise [NoMethodError] Error thrown if method does not reference a hash key.
    #
    # @return [Object] Value in the hash corresponding to the given key.
    def method_missing(meth, *args, &block)
      unless self.keys.find {|k| k.to_sym == meth.to_sym }
        raise NoMethodError, "undefined method `#{meth}' for #{self}"
      end
      self[meth.to_sym]
    end

    # Returns the list of keys for the hash.
    #
    # @return [Array<String>] The list of hash keys.
    def attributes
      self.keys
    end

    # Returns the object represented as a string.
    #
    # @return [String] The class, id, and the to_s method of the parent class.
    def to_s
      "<##{self.class}:#{self.object_id} #{super}>"
    end
  end
end
