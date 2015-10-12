shared_context 'a data model with attribute accessors' do
  let(:test_attrib) { subject.attributes.first }

  describe 'improper access' do
    it 'should raise an exception on attempting to access an attribute without the proper suffix' do
      expect{ subject.send(test_attrib.sub(/_\w$/, '').to_sym) }.to raise_error(NoMethodError)
      expect{ subject.send(test_attrib.to_sym) }.to_not raise_error
    end
  end

  describe 'attribute addition' do
    it 'should raise an error when accessing an attribute prior to addition' do
      expect{ subject.foo }.to raise_error(NoMethodError)
    end

    it 'should add attributes dynamically' do
      subject['foo'] = 'bar'
      expect{ subject.foo }.to_not raise_error
      expect( subject.foo ).to eq('bar')
    end
  end

end
