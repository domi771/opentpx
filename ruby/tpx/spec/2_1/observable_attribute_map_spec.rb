require 'spec_helper_2_1'

describe TPX_2_1::ObservableAttributeMap do
  subject {TPX_2_1::ObservableAttributeMap.new(occurred_at_t: Time.now.getutc.to_i) }
  it_behaves_like 'a TPX 2.1 data model'
end
