require 'spec_helper_2_1'

shared_context 'a TPX 2.1 data model' do
  it_behaves_like 'a data model with mandatory attributes'
  it_behaves_like 'a data model with attribute accessors'

  describe '#to_h' do
    it 'should serialize to a hash' do
      expect(subject.to_h.class).to eq( Hash )
    end
  end
end
