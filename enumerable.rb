# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    arr = self if instance_of?(Array)
    arr = to_a if instance_of?(Range)
    arr = flatten if instance_of?(Hash)

    count = 0
    while count < arr.length
      yield(arr[count])
      count += 1
    end
    arr
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    arr = self if instance_of?(Array)
    arr = to_a if instance_of?(Range)
    arr = flatten if instance_of?(Hash)

    count = 0
    while count < arr.length
      yield(arr[count], count)
      count += 1
    end
    arr
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |it| new_arr << it if yield(it) }
    new_arr
  end

  def my_all?(param = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
      return true
    elsif param.nil?
      my_each { |num| return false if num.nil? || num == false }
    elsif !param.nil? && (param.is_a? Class)
      my_each { |num| return false if num.class != param }
    elsif !param.nil? && param.instance_of?(Regexp)
      my_each { |_num| return false unless arg.match(n) }
    else
      my_each { |_num| return false if n != param }
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
      return true
    elsif param.nil?
      my_each { |num| return true if num.nil? || num == true }
    elsif !param.nil? && (param.is_a? Class)
      my_each { |num| return true if num.instance_of?(param) }
    elsif !param.nil? && param.instance_of?(Regexp)
      my_each { |_num| return true unless arg.match(num) }
    else
      my_each { |_num| return true if num != param }
    end
    true
  end

  def my_none?(*param)
    return "`my_none': wrong arguments(given #{arguments.length}, expected 0..1)" if arguments.length > 1

    if block_given?
      my_each { |num| return false if yield(num) }
    elsif param.empty?
      my_each { |num| return false unless num.nil? || num == false }
    elsif param[0].is_a? Regexp
      my_each { |num| return false if param[0].match(num) }
    else
      my_each { |num| return false if num == param[0] }
    end
    true
  end

  def my_count(num = nil)
    arr = instance_of?(Array) ? self : to_a
    return arr.length unless block_given? || num

    return arr.my_select { |item| item == num }.length if num

    arr.my_select { |item| yield(item) }.length
  end

  def my_map(par_ = nil)
    new_arr = []
    return to_enum unless block_given?

    if par_
      my_each { |i| new_arr << par_.call(i) }
    else
      my_each { |i| new_arr << yield(i) }
    end
    new_arr
  end

  def my_inject(number = nil, syn = nil)
    if block_given?
      acc = number
      my_each { |i| acc = acc.nil? ? i : yield(acc, i) }
      raise LocalJumperError unless block_given? || !syn.empty? || !number.empty?

      acc
    elsif !number.nil? && (number.is_a?(Symbol) || number.is_a?(String))
      raise LocalJumperError unless block_given? || !number.empty?

      acc = nil
      my_each { |i| acc = acc.nil? ? i : acc.send(number, i) }
      acc
    elsif !syn.nil? && (syn.is_a?(Symbol) || syn.is_a?(String))
      raise LocalJumperError unless block_given? || !syn.empty?

      acc = number
      my_each { |i| acc = acc.nil? ? i : acc.send(syn, i) }
      acc
    else
      raise LocalJumperError
    end
  end
end
# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  array.my_inject(:*)
end
