require 'tpx/2_2/data_model'
require 'tpx/2_2/observable_attribute_map'
require 'tpx/2_2/classification_element_list'

module TPX_2_2

  # The definition of an observable.
  class ObservableDefinition < DataModel
    MANDATORY_ATTRIBUTES = [
      :observable_id_s, # TODO: Clarify handling of file hash in specification document
      :description_s,
      :classification_c_array,
    ]
  end
end
