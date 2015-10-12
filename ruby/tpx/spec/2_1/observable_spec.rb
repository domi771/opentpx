require 'spec_helper_2_1'

describe TPX_2_1::Observable do
  subject {TPX_2_1::Observable.new(observable_id_s: 'Malware')}
  it_behaves_like 'a TPX 2.1 data model'
end
