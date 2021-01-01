# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
module Enumerable
  def my_each
    return to_enum unless block_given?

    array = to_a
    array.length.times { |element| yield(array[element]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    array = to_a
    array.length.times { |element| yield(array[element], element) }
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |it| new_arr << it if yield(it) }
    new_arr
  end

  def my_all?(*arg)
    return "`my_all?': wrong # of arg (given #{arg.length}, expected 0..1)" if arg.length > 1

    if block_given?
      my_each { |element| return false unless yield(element) }
    elsif arg[0].is_a? Class
      my_each { |element| return false unless element.class.ancestors.include?(arg[0]) }
    elsif arg[0].is_a? Regexp
      my_each { |element| return false unless arg[0].match(element) }
    elsif arg.empty?
      return include?(nil) || include?(false) ? false : true
    else
      my_each { |element| return false unless element == arg[0] }
    end
    true
  end

  def my_any?(*arg)
    return "`my_any?': wrong number of arg (given #{arg.length}, expected 0..1)" if arg.length > 1

    if block_given?
      my_each { |element| return true if yield(element) }
    elsif arg.empty?
      my_each { |element| return true if element }
      false
    elsif arg[0].is_a? Class
      my_each { |element| return true if element.class.ancestors.include?(arg[0]) }
    elsif arg[0].is_a? Regexp
      my_each { |element| return true if arg[0].match(element) }
    else
      my_each { |element| return true if element == arg[0] }
    end
    false
  end

  def my_none?(*param)
    return "`my_none': wrong arguments(given #{param.length}, expected 0..1)" if param.length > 1

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

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
def multiply_els(array)
  array.my_inject(:*)
end
