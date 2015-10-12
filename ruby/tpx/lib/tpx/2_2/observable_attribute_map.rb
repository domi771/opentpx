require 'tpx/2_2/data_model'

module TPX_2_2

  # An map of attributes associated with the observable
  # that are common across all subjects
  class ObservableAttributeMap < DataModel
    MANDATORY_ATTRIBUTES = [
      :occurred_at_t
    ]
  end
end
