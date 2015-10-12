require 'spec_helper_2_1'

describe TPX_2_1::NetworkList do
  subject { TPX_2_1::NetworkList.new([ network_1, network_2 ]) }

  let(:network_1) {
    TPX_2_1::Network.new(
      asn_number_i: 1,
      asn_owner_s: 'Technical University'
    )
  }
  let(:network_2) {
    TPX_2_1::Network.new(
      asn_number_i: 2,
      asn_owner_s: 'Technical University'
    )
  }

  it_behaves_like 'a homogeneous list of data models'
end
