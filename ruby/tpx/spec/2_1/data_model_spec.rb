require 'spec_helper_2_1'

class DataModelExample < TPX_2_1::DataModel
  MANDATORY_ATTRIBUTES = [:id]
  MUST_HAVE_ONE_OF_ATTRIBUTES = [[:attr_a_must_have_one, :attr_b_must_have_one]]
  MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES = [[:attr_a_must_have_one_and_only_one, :attr_b_must_have_one_and_only_one]]
end

describe DataModelExample do
  subject{
    DataModelExample.new(
      id: '1',
      attr_a_must_have_one: '1',
      attr_a_must_have_one_and_only_one: '1'
    )
  }

  describe '#initialize' do
    it 'should initialize a new object' do
      expect( subject.class ).to be DataModelExample
    end

    it 'should raise an error when the input parameter is not a Hash' do
      expect{
        DataModelExample.new([])
      }.to raise_error(
        TPX_2_1::ValidationError,
        'Parameter `input_hash` supplied to DataModelExample must be of type Hash (Array: [])!'
      )
    end

    it 'should raise an error when a mandatory attribute is missing' do
      expect{
        DataModelExample.new({  })
      }.to raise_error(
        TPX_2_1::ValidationError,
        'The mandatory attribute `id` is missing from the supplied input_hash paramater to DataModelExample.'
      )
    end

    it 'should raise an error when not provided a member of "must have one of" attributes' do
      expect{
        DataModelExample.new({ id: 'foo' })
      }.to raise_error(
        TPX_2_1::ValidationError,
        'A member of the mandatory attribute set `[:attr_a_must_have_one, :attr_b_must_have_one]` is missing from the supplied input_hash paramater to DataModelExample.'
      )
    end

    it 'should raise an error when not provided a member of "must have one and only one of" attributes' do
      expect{
        DataModelExample.new({ id: 'foo', attr_a_must_have_one: 'bar' })
      }.to raise_error(
        TPX_2_1::ValidationError,
        'A member of the mandatory attribute set `[:attr_a_must_have_one_and_only_one, :attr_b_must_have_one_and_only_one]` is missing from the supplied input_hash paramater to DataModelExample.'
      )
    end

    it 'should raise an error when provided more than one member of "must have one and only one of" attributes' do
      expect{
        DataModelExample.new({ id: 'foo', attr_a_must_have_one: 'bar', attr_a_must_have_one_and_only_one: '1', attr_b_must_have_one_and_only_one: '2' })
      }.to raise_error(
        TPX_2_1::ValidationError,
        'More than one member of the exclusive and mandatory attribute set `[:attr_a_must_have_one_and_only_one, :attr_b_must_have_one_and_only_one]` was provided to DataModelExample.'
      )
    end
  end

  describe '#to_h' do
    it 'should output a Hash' do
      expect( subject.to_h.class ).to be Hash
    end
  end
end
