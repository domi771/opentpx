require 'tpx/2_2/homogeneous_list'
require 'tpx/2_2/observable_definition'

module TPX_2_2

  # A dictionary of observable objects.
  class ObservableDictionary < HomogeneousList
    homogeneous_list_of ObservableDefinition
    children_keyed_by :observable_id_s
  end

end
