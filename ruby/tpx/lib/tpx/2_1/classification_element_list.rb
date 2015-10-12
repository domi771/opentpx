require 'tpx/2_1/homogeneous_list'
require 'tpx/2_1/classification_element'

module TPX_2_1

  # A list of classifications of an observable.
  class ClassificationElementList < HomogeneousList
    homogeneous_list_of ClassificationElement
    children_keyed_by :classification_id_s
  end
end
