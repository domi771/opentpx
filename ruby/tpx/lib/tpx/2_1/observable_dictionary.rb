require 'tpx/2_1/homogeneous_list'
require 'tpx/2_1/observable_definition'

module TPX_2_1

  # A dictionary of observable objects.
  class ObservableDictionary < HomogeneousList
    homogeneous_list_of ObservableDefinition
    children_keyed_by :observable_id_s
  end

end
