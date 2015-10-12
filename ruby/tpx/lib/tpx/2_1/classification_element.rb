require 'tpx/2_1/data_model'

module TPX_2_1

  # An element in a classification list.
  class ClassificationElement < DataModel
    MANDATORY_ATTRIBUTES = [
      :classification_id_s
    ]
  end
end
