require 'tpx/2_1/data_model'

module TPX_2_1

  # A name associated with a measurement of risk including a
  # description of the risk and one or more classifications
  # associated with one or more network elements
  class Observable < DataModel
    MANDATORY_ATTRIBUTES = [
      :observable_id_s
    ]
  end
end
