require 'spec_helper_2_1'

class HeterogeneousListDescendentElement < TPX_2_1::DataModel
  MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES = [
    [:id_a_s, :id_b_s]
  ]
end

class HeterogeneousListDescendent < TPX_2_1::HeterogeneousList
  children_of_class_and_id [
    [HeterogeneousListDescendentElement, :id_a_s],
    [HeterogeneousListDescendentElement, :id_b_s]
  ]
end

describe HeterogeneousListDescendent do
  subject {
    HeterogeneousListDescendent.new( [list_element_1, list_element_2] )
  }
  let(:list_element_1) {
    HeterogeneousListDescendentElement.new({:id_a_s => 1, :attr_1 => 'a'})
  }
  let(:list_element_2) {
    HeterogeneousListDescendentElement.new({:id_b_s => 2, :attr_1 => 'b'})
  }
  let(:list_element_2_dup) {
    HeterogeneousListDescendentElement.new({:id_b_s => 2, :attr_1 => 'b'})
  }
  let(:list_element_3) {
    HeterogeneousListDescendentElement.new({:id_a_s => 3, :attr_1 => 'c'})
  }

  describe '#initialize' do
    it 'should create a new list given valid input' do
      expect{
        HeterogeneousListDescendent.new([list_element_1, list_element_2, list_element_3])
      }.to_not raise_error
    end

    it 'should warn on duplicate input elements' do
      expect{
        HeterogeneousListDescendent.new(
          [list_element_1, list_element_2, list_element_2_dup]
        )
      }.to raise_error(
        TPX_2_1::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HeterogeneousListDescendent!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        HeterogeneousListDescendent.new([ list_element_1, list_element_2, TPX_2_1::DataModel.new({foo: 'bar'}) ])
      }.to raise_error(
        TPX_2_1::ValidationError, 'Supplied input object {"foo"=>"bar"} at position 2 not one of required types [[HeterogeneousListDescendentElement, :id_a_s], [HeterogeneousListDescendentElement, :id_b_s]] in HeterogeneousListDescendent!'
      )
    end
  end

  describe '#<<' do
    it 'should warn on duplicate input elements' do
      expect{
        subject << list_element_2_dup
      }.to raise_error(
        TPX_2_1::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HeterogeneousListDescendent!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        subject << {foo: 'bar'}
      }.to raise_error(
        TPX_2_1::ValidationError, 'Supplied input object {:foo=>"bar"} not one of required types [[HeterogeneousListDescendentElement, :id_a_s], [HeterogeneousListDescendentElement, :id_b_s]] in HeterogeneousListDescendent!'
      )
    end

    it 'should add a new element' do
      expect{
        subject << list_element_3
      }.to_not raise_error
    end
  end

end
