class InvalidElementClassFoo < Hash; end

shared_context 'a merging heterogeneous list of data models' do |default_creation_opts={}|
  let(:invalid_list_element) { InvalidElementClassFoo.new({foo: 'bar'})}

  let(:new_valid_list_element) {
    subject.class.child_types.first[0].new(
      Hash[
        subject.class.child_types.first[0]::MANDATORY_ATTRIBUTES.map do |attrib|
          [
            attrib,
            'TODO: Hopefully this is a string field.  Can we make this more robust?'
          ]
        end
      ].merge( default_creation_opts ).merge(
        Hash[
          subject.class.child_types.first[0]::MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES.map do |attrib_array|
            [
              attrib_array.first,
              'TODO: Hopefully this is a string field.  Can we make this more robust?'
            ]
          end
        ]
      )
    )
  }

  describe 'its relation to children data models' do
    it 'should have the class and child id of data models defined' do
      expect( subject.class.child_types ).to_not be nil
      expect( subject.class.child_types.class ).to be Array
      subject.class.child_types.each do |child_type|
        expect(child_type.class).to be Array
        expect(child_type[0].is_a?(Class)).to be true
        expect(child_type[1].class).to be Symbol
      end
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
      expect{
        self.class.new([new_valid_list_element])
      }.to_not(
        raise_error
      )
    end

    it 'should raise a validation error when the wrong object type is provided' do
      expect{
        subject.class.new([invalid_list_element])
      }.to raise_error(
        TPX_2_2::ValidationError,
        "Supplied input object #{invalid_list_element.inspect} at position 0 not one of required types #{subject.class.child_types} in #{subject.class}!"
      )
    end
  end

  describe '#<<' do
    it 'should accept a new valid list element' do
      expect{ subject << new_valid_list_element }.to_not raise_error
    end

    it 'should raise a validation error when the wrong object type is provided' do
      expect{
        subject << invalid_list_element
      }.to raise_error(
        TPX_2_2::ValidationError,
        "Supplied input object #{invalid_list_element.inspect} not one of required types #{subject.class.child_types} in #{subject.class}!"
      )
    end

    it 'should not raise a validation error when an object with a duplicate id is inserted' do
      expect{ subject << subject.first }.to_not raise_error
    end

    it 'should merge attributes when an object with a duplicate id is inserted' do
      new_element = subject.first.clone
      new_element[subject.class.attributes_to_merge.first][:foo] = 'bar'
      subject << new_element
      expect( subject.first[subject.class.attributes_to_merge.first].has_key?(:foo) ).to be true
      expect( subject.first[subject.class.attributes_to_merge.first][:foo] ).to eq('bar')
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
        expect(subject.class.child_types.map{|ti| ti[0]}.include?(element_observable.class)).to be true
      end
      expect(n > 0).to be true
    end
  end

end
