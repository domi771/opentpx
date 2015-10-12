require "spec_helper_2_1"

class HomogeneousListDescendentElement < TPX_2_1::DataModel
  MANDATORY_ATTRIBUTES = [:id]
end

class HomogeneousListDescendent < TPX_2_1::HomogeneousList
  homogeneous_list_of HomogeneousListDescendentElement
  children_keyed_by :id
end

describe HomogeneousListDescendent do
  subject {
    HomogeneousListDescendent.new( [list_element_1, list_element_2] )
  }
  let(:list_element_1) {
    HomogeneousListDescendentElement.new({:id => 1, :attr_1 => 'a'})
  }
  let(:list_element_2) {
    HomogeneousListDescendentElement.new({:id => 2, :attr_1 => 'b'})
  }
  let(:list_element_2_dup) {
    HomogeneousListDescendentElement.new({:id => 2, :attr_1 => 'b'})
  }
  let(:list_element_3) {
    HomogeneousListDescendentElement.new({:id => 3, :attr_1 => 'c'})
  }

  describe '#initialize' do
    it 'should create a new list given valid input' do
      expect{
        subject.class.new([list_element_1, list_element_2, list_element_3])
      }.to_not raise_error
    end

    it 'should warn on duplicate input elements' do
      expect{
        HomogeneousListDescendent.new(
          [list_element_1, list_element_2, list_element_2_dup]
        )
      }.to raise_error(
        TPX_2_1::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HomogeneousListDescendent!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        HomogeneousListDescendent.new([ list_element_1, list_element_2, TPX_2_1::DataModel.new({foo: 'bar'}) ])
      }.to raise_error(
        TPX_2_1::ValidationError, 'Supplied input object {"foo"=>"bar"} at position 2 not of required type HomogeneousListDescendentElement in HomogeneousListDescendent!'
      )
    end
  end

  describe '#<<' do
    it 'should warn on duplicate input elements' do
      expect{
        subject << list_element_2_dup
      }.to raise_error(
        TPX_2_1::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HomogeneousListDescendent!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        subject << {foo: 'bar'}
      }.to raise_error(
        TPX_2_1::ValidationError, 'Supplied input object {:foo=>"bar"} not of required type HomogeneousListDescendentElement in HomogeneousListDescendent!'
      )
    end

    it 'should add a new element' do
      expect{
        subject << list_element_3
      }.to_not raise_error
    end
  end

end
