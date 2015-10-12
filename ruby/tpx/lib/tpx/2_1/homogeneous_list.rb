require 'tpx/2_1/exceptions'

module TPX_2_1
  # A list (Array) whose elements are all the same type and have the same id attribute (HomogeneousList.child_id).
  class HomogeneousList < Array
    include Enumerable

    class << self
      # The child class type accepted.
      attr_accessor :type
      # The id attribute name of the children objects.
      attr_accessor :child_id

      # Defines the child class that the list accepts.
      #
      # @param [Class] klass The Class to accept as list members.
      def homogeneous_list_of(klass)
        self.type = klass
      end

      # Defines the child class id attribute name.
      #
      # @param [Symbol] child_id The id field of list members.
      def children_keyed_by(child_id)
        self.child_id = child_id
      end
    end

    # Hash lookup accessor to list members.
    # Hash of hashes like child_id_of[ChildClass][child_id_val] = child
    attr_accessor :child_id_of

    # Initialize a new HomogeneousList from an Array.
    #
    # @param [Array] input_array The Array of HomogeneousList.type classes (or Hash to be initialized as HomogeneousList.type classes) to create the HomogeneousList object from.
    def initialize(input_array)
      unless input_array.is_a? Array
        raise ValidationError, "Supplied parameter (#{input_array.inspect}) to #{self.class}#initialize should be of type Array!"
      end
      @child_id_of = {}
      input_array.each_with_index do |child, i|
        if child.class == Hash || child.class == HashWithIndifferentAccess
          child = self.class.type.new(child)
        end
        validate_homogeneous_type_of(child, i)
        validate_unique(child)
        @child_id_of[child[self.class.child_id]] = child
      end
      super input_array
    end

    # Add a new child to the HomogeneousList (push).
    #
    # @param [Hash or HomogeneousList.type] child The object to add to the HomogeneousList.
    def <<(child)
      validate_homogeneous_type_of(child)
      validate_unique(child)
      @child_id_of[child[self.class.child_id]] = child
      super child
    end

    # Validate that a child is of the proper type to add to the HomogeneousList.
    #
    # @param [Hash or HomogeneousList.type] child The object to verify is one of HomogeneousList.type.
    # @param [Integer] i The position, if any, in the list of the object to verify is one of HomogeneousList.type.
    def validate_homogeneous_type_of(child, i=nil)
      unless child.is_a? self.class.type
        pos_msg = i.nil? ? '' : " at position #{i}"
        raise ValidationError, "Supplied input object #{child.inspect}#{pos_msg} not of required type #{self.class.type} in #{self.class}!"
      end
    end

    # Validate that a child is not contained in the list prior to adding to the HomogeneousList.
    #
    # @param [Hash or HomogeneousList.type] child The object to verify is not already contained in HomogeneousList.
    def validate_unique(child)
      if @child_id_of.has_key?(child[self.class.child_id])
        raise TPX_2_1::DuplicateElementInsertError, "Duplicate input object id #{child[self.class.child_id]} provided to #{self.class}!"
      end
    end
  end
end
