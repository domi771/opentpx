require 'spec_helper_2_2'

describe TPX_2_2::Network do
  subject {
    TPX_2_2::Network.new(
      asn_number_ui: 1,
      occurred_at_t: 1212312323,
      asn_owner_s: 'ABC Corp'
    )
  }

  it_behaves_like 'a TPX 2.2 data model'
end
