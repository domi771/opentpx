require 'spec_helper_2_2'

describe TPX_2_2::Observable do
  subject {TPX_2_2::Observable.new(observable_id_s: 'Malware')}
  it_behaves_like 'a TPX 2.2 data model'
end
