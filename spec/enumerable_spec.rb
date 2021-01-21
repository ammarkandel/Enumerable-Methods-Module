require '../lib/enumerable'

describe Enumerable do
  let(:range) { (1..9) }
  let(:test_arr_one) { [1, 1, 1, 1] }
  let(:test_arr_two) { [2, 4, 6, 8] }
  describe '#my_each' do
    it 'expect my each to return array item' do
      expect(test_arr_two.my_each { |i| i }).to eql(test_arr_two)
    end

    it 'expect my each to eql range from 1 to 9' do
      expect(range.my_each { |i| i }).to eql(range)
    end

    it 'expect my each to be enumarator' do
      expect(test_arr_two.my_each).to be_an(Enumerator)
    end

    it 'expect my each to not eql range from 1 to 9' do
      expect(range.my_each { |i| i }).not_to eql((15..20))
    end
  end

  describe '#my_select' do
    it 'expect my_select to be enumarator' do
      expect(test_arr_two.my_select).to be_an(Enumerator)
    end

    it 'expect my each to eql selected items' do
      expect(test_arr_two.my_select(&:even?)).to eql(test_arr_two.my_select(&:even?))
    end

    it 'expect my each to eql selected items' do
      expect(test_arr_two.my_select(&:even?)).not_to eql(test_arr_two.my_select(&:odd?))
    end
  end

  describe '#my_any?' do
    it 'expect my_any to return true if the argument in the array' do
      expect([4, 5, true, 6].my_any?(true)).to eql(true)
    end

    it 'expect my_any to return true if false in the array' do
      expect([4, 5, false, 6].my_any?(false)).to eql(true)
    end

    it 'expect my_any to return false if argument not in the array' do
      expect([4, 5, false, 6].my_any?(10)).to eql(false)
    end

    it 'expect my_any to return true if the argument in the array' do
      expect([4, 5, 20, 6].my_any?(20)).to eql(true)
    end

    it 'expect my_any to return true if the argument in the range' do
      expect((1..20).my_any?(20)).to eql(true)
    end

    it 'expect my_any to return false if the argument not in the range' do
      expect((1..20).my_any?(30)).to eql(false)
    end
  end

  describe '#my_all' do
    it 'expect my_all to return true if all items equal the argument' do
      expect(test_arr_one.my_all?(1)).to eql(true)
    end

    it 'expect my_all to return false if not all items equal the argument' do
      expect([1, 1, 1, 2].my_all?(1)).to eql(false)
    end

    it 'expect my_all to return false if not all items greater than 10' do
      expect(test_arr_one.my_all? { |i| i > 10 }).to eql(false)
    end

    it 'expect my_all to return true if all item less than 10' do
      expect(test_arr_one.my_all? { |i| i < 10 }).to eql(true)
    end
  end

  describe '#my_map' do
    it 'expect my_map to return true' do
      expect(test_arr_one.my_map { |i| i * 2 }).to eql([2, 2, 2, 2])
    end

    it 'expect my_map to return true' do
      expect((1..4).my_map { |i| i * 1 }).to eql([1, 2, 3, 4])
    end

    it 'expect my_map to not be this array' do
      expect((1..4).my_map { |i| i * 1 }).not_to eql([1, 2, 3, 5])
    end
  end

  describe '#my_each_with_index' do
    it 'expect my each to return array item' do
      expect(test_arr_two.my_each_with_index { |i| i }).to eql(test_arr_two)
    end

    it 'expect my each to eql range from 1 to 9' do
      expect(range.my_each_with_index { |i| i }).to eql(range)
    end

    it 'expect my each to not eql range from 1 to 9' do
      expect(range.my_each_with_index { |i| i }).not_to eql((15..20))
    end

    it 'expect my each to be enumarator' do
      expect(test_arr_two.my_each_with_index).to be_an(Enumerator)
    end
  end

  describe '#my_count' do
    it 'expect my count to return 2' do
      expect([2, 4, 6, 8, 10].my_count { |item| item > 4 }).to eql(3)
    end

    it 'expect my count to return 2' do
      expect([1, 2, 2, 6, 8, 9].my_count { |item| item == 2 }).to eql(2)
    end

    it 'expect my count to return 2' do
      expect([1, 2, 2, 6, 8, 9].my_count { |item| item == 2 }).not_to eql(4)
    end
  end

  describe '#my_none' do
    it 'expect my_none to return true' do
      expect(test_arr_one.my_none?(10)).to eql(true)
    end

    it 'expect my_none to return false' do
      expect([1, 1, 1, 2].my_none?(1)).to eql(false)
    end

    it 'expect my_none to return true' do
      expect(test_arr_one.my_none? { |i| i > 10 }).to eql(true)
    end

    it 'expect my_none to return false' do
      expect(test_arr_one.my_none? { |i| i < 10 }).to eql(false)
    end
  end

  describe '#my_inject' do
    let(:arr) { [1, 2, 3, 4] }
    it 'expect my_inject to accept sympol' do
      expect(arr.my_inject(:*)).to eql(24)
    end

    it 'expect my_inject to accept sympol and number' do
      expect(arr.my_inject(0, :+)).to eql(10)
    end

    it 'test if range given' do
      expect(range.my_inject { |i| i == false }).to eql(true)
    end

    it 'expect my_inject to accept sympol and number' do
      expect(arr.my_inject(0, :+)).not_to eql(12)
    end
  end
end
