require 'spec_helper_2_2'

class HeterogeneousListDescendentElement_2_2 < TPX_2_2::DataModel
  MUST_HAVE_ONE_AND_ONLY_ONE_OF_ATTRIBUTES = [
    [:id_a_s, :id_b_s]
  ]
end

class HeterogeneousListDescendent_2_2 < TPX_2_2::HeterogeneousList
  children_of_class_and_id [
    [HeterogeneousListDescendentElement_2_2, :id_a_s],
    [HeterogeneousListDescendentElement_2_2, :id_b_s]
  ]
end

describe HeterogeneousListDescendent_2_2 do
  subject {
    HeterogeneousListDescendent_2_2.new( [list_element_1, list_element_2] )
  }
  let(:list_element_1) {
    HeterogeneousListDescendentElement_2_2.new({:id_a_s => 1, :attr_1 => 'a'})
  }
  let(:list_element_2) {
    HeterogeneousListDescendentElement_2_2.new({:id_b_s => 2, :attr_1 => 'b'})
  }
  let(:list_element_2_dup) {
    HeterogeneousListDescendentElement_2_2.new({:id_b_s => 2, :attr_1 => 'b'})
  }
  let(:list_element_3) {
    HeterogeneousListDescendentElement_2_2.new({:id_a_s => 3, :attr_1 => 'c'})
  }

  describe '#initialize' do
    it 'should create a new list given valid input' do
      expect{
        HeterogeneousListDescendent_2_2.new([list_element_1, list_element_2, list_element_3])
      }.to_not raise_error
    end

    it 'should warn on duplicate input elements' do
      expect{
        HeterogeneousListDescendent_2_2.new(
          [list_element_1, list_element_2, list_element_2_dup]
        )
      }.to raise_error(
        TPX_2_2::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HeterogeneousListDescendent_2_2!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        HeterogeneousListDescendent_2_2.new([ list_element_1, list_element_2, TPX_2_2::DataModel.new({foo: 'bar'}) ])
      }.to raise_error(
        TPX_2_2::ValidationError, 'Supplied input object {"foo"=>"bar"} at position 2 not one of required types [[HeterogeneousListDescendentElement_2_2, :id_a_s], [HeterogeneousListDescendentElement_2_2, :id_b_s]] in HeterogeneousListDescendent_2_2!'
      )
    end
  end

  describe '#<<' do
    it 'should warn on duplicate input elements' do
      expect{
        subject << list_element_2_dup
      }.to raise_error(
        TPX_2_2::DuplicateElementInsertError,
        'Duplicate input object id 2 provided to HeterogeneousListDescendent_2_2!'
      )
    end

    it 'should ensure all items are the proper type' do
      expect{
        subject << {foo: 'bar'}
      }.to raise_error(
        TPX_2_2::ValidationError, 'Supplied input object {:foo=>"bar"} not one of required types [[HeterogeneousListDescendentElement_2_2, :id_a_s], [HeterogeneousListDescendentElement_2_2, :id_b_s]] in HeterogeneousListDescendent_2_2!'
      )
    end

    it 'should add a new element' do
      expect{
        subject << list_element_3
      }.to_not raise_error
    end
  end

end
