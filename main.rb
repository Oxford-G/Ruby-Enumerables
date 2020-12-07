# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ModuleLength, Style/For
module Enumerable
  # 1.my_each
  def my_each
    return to_enum unless block_given?

    for i in self
      yield(i)
    end
    self
  end

  # 2. my_each_with_index
  def my_each_with_index
    return to_enum unless block_given?

    for i in (0..self).size - 1
      yield(self[i], i)
    end
    self
  end

  # 3. my_select
  def my_select
    return to_enum unless block_given?

    result = []
    each do |item|
      result << item if yield(item)
    end
    result
  end

  # 4. my_all
  def my_all?(parameter = nil)
    result = true
    if block_given?
      my_each { |value| return false unless yield(value) }
    else
      case parameter
      when nil
        my_each { |value| return false if value.nil? || !value }
      when Regexp
        my_each { |value| return false unless value =~ parameter }
      when Class
        my_each { |value| return false unless value.is_a? parameter }
      else
        my_each { |value| return false unless value == parameter }
      end
    end
    result
  end

  # 4. my_any
  def my_any?(parameter = nil)
    result = false
    if block_given?
      my_each do |x|
        result = true if yield(x)
      end
      result
    else
      case parameter
      when nil
        my_each { |x| return true unless x.nil? || !x }
      when Regexp
        my_each { |x| return true if x =~ parameter }
      when Class
        my_each { |x| return true if x.is_a? parameter }
      else
        my_each { |x| return true if x == parameter }
      end
    end
    result
  end

  # 6.my_none?
  def my_none?(parameter = nil)
    result = true
    if block_given?
      my_each do |x|
        result = false if yield(x)
      end
      result
    else
      case parameter
      when nil
        my_each { |x| return false unless x.nil? || !x }
      when Regexp
        my_each { |x| return false if x =~ parameter }
      when Class
        my_each { |x| return false if x.is_a? parameter }
      else
        my_each { |x| return false if x == parameter }
      end
    end
    result
  end

  # 7.my_count
  def my_count(parameter = nil)
    counter = 0
    if block_given?
      my_each { |value| counter += 1 if yield(value) }
      counter
    else
      case parameter
      when nil
        size
      when Numeric
        my_each { |x| counter += 1 if parameter == x }
        counter
      end
    end
  end

  # 8.my_map
  def my_map(parameter = nil)
    return to_enum unless block_given?

    result_arr = []
    my_each { |x| result_arr << yield(x) } if parameter.nil?
    my_each { |x| result_arr << parameter.call(x) } unless parameter.nil?
    result_arr
  end

  # 9.my_inject
  def my_inject(*parameter)
    (raise LocalJumpError if !block_given? && parameter[0].nil? && parameter[1].nil?)
    if block_given?
      net = parameter[0] ? yield(first, parameter[0]) : first
      drop(1).my_each { |item| net = yield(net, item) }
    elsif parameter[0]
      if parameter[1]
        net = parameter[0]
        my_each { |item| net = net.send(parameter[1], item) }
      else
        net = first
        drop(1).my_each { |item| net = net.send(parameter[0], item) }
      end
    end
    net
  end
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/ModuleLength, Style/For

def multiply_els(parameter)
  parameter.my_inject { |sum, x| sum * x }
end
