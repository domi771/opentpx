require 'tpx/2_2/heterogeneous_list'

module TPX_2_2
  # A list (Array) whose elements are not all the same type or do not have the same id attribute
  #   and who merges certain attributes on duplicate object insert.
  # The MergingHeterogenousList defines an array of [ChildClass, child_id_attribute_name] as the accepted :child_types.
  class MergingHeterogeneousList < HeterogeneousList

    class << self
      # This list of attributes to merge on duplicate object id insert.
      attr_accessor :attributes_to_merge

      def on_duplicate_addition_merge_attributes(attributes)
        self.attributes_to_merge = attributes
      end
    end

    # Add a new child to the MergingHeterogenousList (push). Merge `attributes_to_merge` on a duplicate child id insert.
    #
    # @param [Hash or MergingHeterogenousList.type] child The object to add to the MergingHeterogenousList.
    def <<(child)
      child_type = validate_expected_child_type(child)
      if child_id_of.has_key?(child_type[0]) && child_id_of[child_type[0]].has_key?(child[child_type[1]])
        self.class.attributes_to_merge.each do |attribute|
          child_id_of[child_type[0]][child[child_type[1]]][attribute].merge!(child[attribute])
        end
      else
        child_id_of[child_type[0]] ||= {}
        child_id_of[child_type[0]][child[child_type[1]]] = child
        meth = Array.instance_method(:<<)
        meth.bind(self).call(child)
      end
    end

  end
end
