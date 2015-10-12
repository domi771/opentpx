require 'tpx/2_2/homogeneous_list'
require 'tpx/2_2/network'

module TPX_2_2

  # A list of network objects.
  class NetworkList < HomogeneousList
    homogeneous_list_of Network
    children_keyed_by :asn_number_ui
  end
end
