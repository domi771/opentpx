require 'spec_helper_2_2'

describe TPX_2_2::ObservableAttributeMap do
  subject {TPX_2_2::ObservableAttributeMap.new(occurred_at_t: Time.now.getutc.to_i) }
  it_behaves_like 'a TPX 2.2 data model'
end
