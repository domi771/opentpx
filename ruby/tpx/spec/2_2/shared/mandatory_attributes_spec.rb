shared_context 'a data model with mandatory attributes' do |default_creation_opts={}|
  let(:mandatory_attribute_hash) {
    Hash[
        subject.class::MANDATORY_ATTRIBUTES.map do |attrib|
          [
            attrib,
            'TODO: Hopefully this is a string field.  Can we make this more robust?'
          ]
        end
      ].merge( default_creation_opts )
  }

  describe '#initialize' do
    it 'should create an object when mandatory attributes are provided' do
      expect{ self.class.new(mandatory_attribute_hash) }.to_not raise_error
    end

    it 'should raise a validation error when a mandatory value is not supplied' do
      unless subject.class::MANDATORY_ATTRIBUTES.empty?
        expect{ subject.class.new({}) }.to raise_error(TPX_2_2::ValidationError)
      end
    end
  end

end
