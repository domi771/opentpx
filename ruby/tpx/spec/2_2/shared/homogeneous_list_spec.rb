shared_context 'a homogeneous list of data models' do |default_creation_opts={}|
  class InvalidElementClassFoo; end

  let(:new_valid_list_element) {
    subject.class.type.new(
      Hash[
        subject.class.type::MANDATORY_ATTRIBUTES.map do |attrib|
          [
            attrib,
            'TODO: Hopefully this is a string field.  Can we make this more robust?'
          ]
        end
      ].merge( default_creation_opts )
    )
  }

  describe 'its relation to children data models' do
    it 'should have the child id of data models defined' do
      expect( subject.class.child_id ).to_not be nil
      expect( subject.class.child_id.class ).to be Symbol
    end

    it 'should have the type of data models it contains defined' do
      expect( subject.class.type ).to_not be nil
      expect( subject.class.type.class ).to be Class
    end

    it 'should contain a list of children who are all the same type' do
      types = {}
      subject.each do |child|
        types[child.class] = 1
      end
      expect(types.keys.length).to be 1
    end
  end

  describe '#initialize' do
    it 'should have a valid child element defined that can be initialized' do
      expect{
        new_valid_list_element
      }.to_not(
        raise_error
      )

    end

    it 'should create a new object given all mandatory fields' do
      puts "new_valid_list_element: #{new_valid_list_element.class} #{new_valid_list_element.inspect}"
      expect{
        self.class.new([new_valid_list_element])
      }.to_not(
        raise_error
      )
    end

    it 'should raise a validation error when the wrong object type is provided' do
      expect{ subject.class.new([InvalidElementClassFoo]) }.to raise_error(TPX_2_2::ValidationError)
    end
  end

  describe '#<<' do
    it 'should accept a new valid list element' do
      expect{ subject << new_valid_list_element }.to_not raise_error
    end

    it 'should raise a validation error when the wrong object type is provided' do
      expect{ subject << InvalidElementClassFoo }.to raise_error(TPX_2_2::ValidationError)
    end

    it 'should raise a validation error when an object with a duplicate id is inserted' do
      expect{ subject << subject.first }.to raise_error(TPX_2_2::DuplicateElementInsertError)
    end
  end

  describe '#to_a' do
    it 'should output to a base array' do
      expect(subject.to_a.class).to be Array
    end
  end

  describe '.each' do
    it 'should be instance of Enumerable' do
      expect(subject.is_a?(Enumerable)).to eq(true)
    end

    it 'should have correctly implemented each method' do
      n = 0
      subject.each do |element_observable|
        n += 1
        expect(element_observable.class).to eq(subject.class.type)
      end
      expect(n > 0).to be true
    end
  end

end
