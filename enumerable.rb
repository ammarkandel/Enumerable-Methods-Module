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

  def my_none?(param = nil)
    if !block_given? && param.nil?
      my_each { |num| return true if num }
      return false
    end

    if !block_given? && !param.nil

      if param.is_a?(Class)
        my_each { |num| return false if num.instance_of?(param) }
        return true
      end

      if param.instance_of?(Regexp)
        my_each { |num| return false if arg.match(num) }
        return true
      end

      my_each { |num| return false if num == param }
      true
    end
    my_any? { |it| return false if yield(it) }
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
  if par_
    each { |i| new_arr << par_.call(i) }
  else
    each { |i| new_arr << yield(i) }
    new_arr
  end
end

def my_inject(number = nil, _syn = nil)
  if block_given?
    acc = number
    my_each { |i| acc = acc.nil? ? i : yield(acc, i) }
    acc
  elsif !number.nil? && (number.is_a?(Symbol) || number.is_a?(String))
    acc = nil
    my_each { |i| acc = acc.nil? ? i : acc.send(number, i) }
    acc
  elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
    acc = number
    my_each { |i| acc = acc.nil? ? i : acc.send(sym, i) }
  else
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |result, element| result * element }
end

puts 'my_each if type Array'
puts [1, 2, 3, 4].my_each(&:even?)

puts 'my_each if type Range'
puts(0..5).my_each(&:even?)

puts 'my_each_with_index if type Array'
[5, 6, 7, 8].my_each_with_index do |i, index|
  puts "#{i} have index #{index}"
end

puts 'my_each_with_index if type Range'
(8..15).my_each_with_index do |i, index|
  puts "#{i} have index #{index}"
end

puts 'my select for any type'
puts [8, 90, 6, 3, 4, 1].my_select(&:even?)

puts 'check my all'
puts [2, 4, 6, 8].my_all?(&:even?)

puts 'check if any of my'
puts [1, 3, 5, 7].my_all?(&:even?)

puts 'check if none of my'
puts [1, 3, 5, 8].my_none?(&:even?)

num = %w[a s f r].count('n')
puts num

num = %w[a s f r].my_count('n')
puts num

p [1, 2, 3, 4].map { |i| i * i }
p [1, 2, 3, 4].my_map { |i| i * i }

p (0..5).map { |i| i * i }
p (0..5).my_map { |i| i * i }

my_proc = proc { |i| i * i }
p [0, 1, 2, 3, 4].map(&my_proc)
p [0, 1, 2, 3, 4].my_map(&my_proc)

p (5..10).my_inject { |x, y| x + y }
p [5, 5, 7, 8].my_inject(1) { |x, y| x * y }

puts 'multiply_els'
p multiply_els([4, 5, 8, 9])
end