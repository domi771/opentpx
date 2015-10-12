require 'spec_helper_2_2'

class HomogeneousListDescendentElement_2_2 < TPX_2_2::DataModel
  MANDATORY_ATTRIBUTES = [:id]
end

class HomogeneousListDescendent_2_2 < TPX_2_2::HomogeneousList
  homogeneous_list_of HomogeneousListDescendentElement_2_2
  children_keyed_by :id
end

describe HomogeneousListDescendent_2_2 do
  subject {
    HomogeneousListDescendent_2_2.new( [list_element_1, list_element_2] )
  }
  let(:list_element_1) {
    HomogeneousListDescendentElement_2_2.new({:id => 1, :attr_1 => 'a'})
  }
  let(:list_element_2) {
    HomogeneousListDescendentElement_2_2.new({:id => 2, :attr_1 => 'b'})
  }
  let(:list_element_2_dup) {
    HomogeneousListDescendentElement_2_2.new({:id => 2, :attr_1 => 'b'})
  }
  let(:list_element_3) {
    HomogeneousListDescendentElement_2_2.new({:id => 3, :attr_1 => 'c'})
  }

  describe '#initialize' do
    it 'should create a new list given valid input' do
      expect{
        subject.class.new([list_element_1, list_element_2, list_element_3])
      }.to_not raise_error
    end

    it 'should warn on duplicate input elements' do
      expect{
        HomogeneousListDescendent_2_2.new(
          [list_element_1, list_element_2, list_element_2_dup]
        )
      }.to raise_error(
        TPX_2_2::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HomogeneousListDescendent_2_2!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        HomogeneousListDescendent_2_2.new([ list_element_1, list_element_2, TPX_2_2::DataModel.new({foo: 'bar'}) ])
      }.to raise_error(
        TPX_2_2::ValidationError, 'Supplied input object {"foo"=>"bar"} at position 2 not of required type HomogeneousListDescendentElement_2_2 in HomogeneousListDescendent_2_2!'
      )
    end
  end

  describe '#<<' do
    it 'should warn on duplicate input elements' do
      expect{
        subject << list_element_2_dup
      }.to raise_error(
        TPX_2_2::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HomogeneousListDescendent_2_2!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        subject << {foo: 'bar'}
      }.to raise_error(
        TPX_2_2::ValidationError, 'Supplied input object {:foo=>"bar"} not of required type HomogeneousListDescendentElement_2_2 in HomogeneousListDescendent_2_2!'
      )
    end

    it 'should add a new element' do
      expect{
        subject << list_element_3
      }.to_not raise_error
    end
  end

end
