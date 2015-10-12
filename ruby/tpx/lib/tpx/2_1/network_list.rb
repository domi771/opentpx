require 'tpx/2_1/homogeneous_list'
require 'tpx/2_1/network'

module TPX_2_1

  # A list of network objects.
  class NetworkList < HomogeneousList
    homogeneous_list_of Network
    children_keyed_by :asn_number_i
  end
end
