  require 'tpx/2_1/exceptions'

module TPX_2_1
  # A list (Array) whose elements are not all the same type or do not have the same id attribute.
  # The HeterogenousList defines an array of [ChildClass, child_id_attribute_name] as the accepted :child_types.
  class HeterogeneousList < Array
    include Enumerable

    class << self
      # The types of objects and their id attribute names accepted by the HeterogeneousList.
      # An Array of Arrays like [[ChildClass, child_id_attribute], [AnotherChildClass, another_child_id_attribute]].
      attr_accessor :child_types

      # Defines the child class types that the list accepts.  Another accessor for `child_types`.
      #
      # @param [Array] child_class_id_array The list of [Class, id_atttribute_name] to accept as list members.
      def children_of_class_and_id(child_class_id_array)
        self.child_types = child_class_id_array
      end
    end

    # Hash lookup accessor to list members.
    # Hash of hashes like child_id_of[ChildClass][child_id_val] = child
    attr_accessor :child_id_of

    # Initialize a new HeterogeneousList from an Array.
    #
    # @param [Array] input_array The Array of HeterogeneousList.child_types included classes (or Hash to be initialized as HeterogeneousList.child_type classes) to create the HeterogeneousList object from.
    def initialize(input_array)
      unless input_array.is_a? Array
        raise ValidationError, "Supplied parameter (#{input_array.inspect}) to #{self.class}#initialize should be of type Array!"
      end

      @child_id_of = {}
      validated_array = []

      input_array.each_with_index do |child, i|
        validate_expected_child_type(child, i)
        new_initialized_child = nil
        new_initialized_child_type = nil

        self.class.child_types.each do |child_type|
          if child.class == child_type[0] && child.has_key?(child_type[1])
            new_initialized_child = child
            new_initialized_child_type = child_type
            break
          elsif child.has_key?(child_type[1])
            new_initialized_child = child_type[0].new(child)
            new_initialized_child_type = child_type
            break
          end
        end

        if new_initialized_child
          validate_unique(new_initialized_child, new_initialized_child_type)
          child_id_of[new_initialized_child_type[0]] ||= {}
          child_id_of[new_initialized_child_type[0]][new_initialized_child[new_initialized_child_type[1]]] = new_initialized_child
          validated_array << new_initialized_child
        end
      end

      super validated_array
    end

    # Add a new child to the HeterogeneousList (push).
    #
    # @param [Hash or HeterogeneousList.type] child The object to add to the HeterogeneousList.
    def <<(child)
      child_type = validate_expected_child_type(child)
      validate_unique(child, child_type)
      child_id_of[child_type[0]] ||= {}
      child_id_of[child_type[0]][child[child_type[1]]] = child
      super child
    end

    # Validate that a child is of the proper type to add to the HeterogeneousList.
    #
    # @param [Hash or one of HeterogeneousList.child_types] child The object to verify is one of HeterogeneousList.child_types.
    # @param [Integer] i The position, if any, in the list of the object to verify is one of HeterogeneousList.child_types.
    def validate_expected_child_type(child, i=nil)
      if child.class == Hash || child.class == HashWithIndifferentAccess
        validate_expected_child_type_from_hash(child, i)
      else
        validate_expected_child_type_from_initialized_object(child, i)
      end
    end

    # Validate that a child is of the proper type to add to the HeterogeneousList.
    #
    # @param [Hash] child The object to verify is one of HeterogeneousList.child_types.
    # @param [Integer] i The position, if any, in the list of the object to verify is one of HeterogeneousList.child_types.
    def validate_expected_child_type_from_hash(child, i=nil)
      child_type_key_count = 0
      child_type_found = nil
      self.class.child_types.each do |child_type|
        if child.has_key?(child_type[1])
          child_type_key_count += 1
          child_type_found = child_type
        end
      end
      if child_type_key_count > 1
        raise ValidationError, "Supplied input object #{child.inspect}#{pos_msg} has multiple subject types in #{self.class}!"
      elsif child_type_key_count == 0
        raise ValidationError, "Supplied input object #{child.inspect}#{pos_msg(i)} not one of required types #{self.class.child_types} in #{self.class}!"
      end
      return child_type_found
    end

    # Validate that a child is of the proper type to add to the HeterogeneousList.
    #
    # @param [one of HeterogeneousList.child_types] child The object to verify is one of HeterogeneousList.child_types.
    # @param [Integer] i The position, if any, in the list of the object to verify is one of HeterogeneousList.child_types.
    def validate_expected_child_type_from_initialized_object(child, i=nil)
      self.class.child_types.each do |child_type|
        if child.class == child_type[0] && child.has_key?(child_type[1])
          return child_type
        end
      end
      raise ValidationError, "Supplied input object #{child.inspect}#{pos_msg(i)} not one of required types #{self.class.child_types} in #{self.class}!"
    end

    def pos_msg(i)
      pos_msg = i.nil? ? '' : " at position #{i}"
    end

    # Validate that a child is not contained in the list prior to adding to the HeterogeneousList.
    #
    # @param [Hash or HeterogeneousList.type] child The object to verify is not already contained in HeterogeneousList.
    def validate_unique(child, child_type)
      if child_id_of.has_key?(child_type[0]) and child_id_of[child_type[0]].has_key?(child[child_type[1]])
        raise TPX_2_1::DuplicateElementInsertError, "Duplicate input object id #{child[child_type[1]]} provided to #{self.class}!"
      end
    end

  end
end
