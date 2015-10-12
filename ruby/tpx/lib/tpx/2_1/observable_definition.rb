require 'tpx/2_1/data_model'
require 'tpx/2_1/observable_attribute_map'
require 'tpx/2_1/classification_element_list'

module TPX_2_1

  # The definition of an observable.
  class ObservableDefinition < DataModel
    MANDATORY_ATTRIBUTES = [
      :observable_id_s, # TODO: Clarify handling of file hash in specification document
      :description_s,
      :classification_c_array,
    ]
  end
end
