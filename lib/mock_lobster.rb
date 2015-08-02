require 'ostruct'

class Object
  def mock(method)
    Mock.new(method)
  end

  def stubbify(hash)
    index = 0
    hash.each do |method_name, return_value|
      if methods.include?(hash.to_a[index].first)
        instance_variable_set("@copied_#{method_name}", method(hash.to_a[index].first))
        index += 1
        (@altered_methods ||= []) << method_name
      end
      self.send(:define_singleton_method, method_name) { return_value }
    end
  end

  def reset
    modified_variables = instance_variables.select {|e| e.to_s if e.to_s.include?("copied")}
    @altered_methods.each do |name|
      self.send(:define_singleton_method, name) do
        instance_variable_get("@copied_" + name.to_s).call
      end
      modified_variables.shift  #
    end
  end


#  def expect(method, param)
#    Expectation.new(method, param, self)
#  end
end

class Mock
  def initialize(method)
    method.each do |method_name, return_value|
      self.send(:define_singleton_method, method_name) do
        return_value
      end
    end
  end
end

#class Expectation
#  attr_accessor :method, :self, :param   # => nil
#  def initialize(method, param, object)
#    @method = method
#    @object = object
#  end
#
#  def returns(result)
#    @object.send(:define_singleton_method, method) { |param| result }
#    result
#  end
#end
