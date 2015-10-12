require 'tpx/2_1/data_model'
require 'tpx/2_1/observable'


module TPX_2_1
  
  # The representation of the threat observable (the hash map keyed
  # by the observable_id within the element observable).
  class ThreatObservable < Observable
    MANDATORY_ATTRIBUTES = Observable::MANDATORY_ATTRIBUTES + [
      :occurred_at_t
    ]
  end # class
end
