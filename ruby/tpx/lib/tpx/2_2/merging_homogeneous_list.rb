module TPX_2_2
  # A list (Array) whose elements are all the same type and have the same id attribute
  #   (MergingHomogeneousList.child_id) and who merges certain attributes on duplicate object insert.
  class MergingHomogeneousList < HomogeneousList

    class << self
      # This list of attributes to merge on duplicate object id insert.
      attr_accessor :attributes_to_merge

      # Defines the child attribute names that the list will merge when an object of the same id as an existing list member is inserted.
      # Another accessor for `attributes_to_merge`.
      #
      # @param [Array] attributes The list of attribute names to merge.
      def on_duplicate_addition_merge_attributes(attributes)
        self.attributes_to_merge = attributes
      end
    end

    # Add a new child to the MergingHomogeneousList (push). Merge `attributes_to_merge` on a duplicate child id insert.
    #
    # @param [Hash or MergingHomogeneousList.type] child The object to add to the MergingHomogeneousList.
    def <<(child)
      unless child.is_a?(self.class.type) && child.has_key?(self.class.child_id)
        raise TPX_2_2::ValidationError, "Element provided to #{self.class}#<< must be #{self.class.type} with key `#{self.class.child_id}`."
      end
      element = self.find {|e| e[self.class.child_id] == child[self.class.child_id] }
      if element.nil?
        super
      else
        self.class.attributes_to_merge.each do |attribute|
          element[attribute].merge!(child[attribute])
        end
      end
    end

  end
end
