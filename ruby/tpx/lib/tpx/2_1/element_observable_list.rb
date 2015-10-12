require 'tpx/2_1/merging_heterogeneous_list'
require 'tpx/2_1/element_observable'

module TPX_2_1

  # A list of element_observables.
  class ElementObservableList < MergingHeterogeneousList

    children_of_class_and_id(
      ElementObservable::SUBJECT_ATTRIBUTES.map do |subject_attribute_name|
        [ElementObservable, subject_attribute_name]
      end
    )
    on_duplicate_addition_merge_attributes [:threat_observable_c_map]

  end # class
end
