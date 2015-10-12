require 'spec_helper_2_1'

describe TPX_2_1::Network do
  subject {
    TPX_2_1::Network.new(
      asn_number_i: 1,
      occurred_at_t: 1212312323,
      asn_owner_s: 'ABC Corp'
    )
  }

  it_behaves_like 'a TPX 2.1 data model'
end
