require 'tpx/2_2/data_model'

module TPX_2_2

  # An element in a classification list.
  class ClassificationElement < DataModel
    MANDATORY_ATTRIBUTES = [
      :classification_id_s
    ]
  end
end
