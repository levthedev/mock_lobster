require 'ostruct'
class Object
  def mock(method)
    Mock.new(OpenStruct.new(method))
  end

  def stub(method)
    method.each_pair do |method_name, return_value|
      self.send(:define_singleton_method, method_name) do
        return return_value
      end
    end
  end

  def expect(method, param)
    Expectation.new(method, param, self)
  end
end

class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|
      self.send(:define_singleton_method, method_name) do
        return return_value
      end
    end
  end
end

class Expectation
  attr_accessor :method, :self, :param   # => nil
  def initialize(method, param, object)
    @method = method
    @object = object
  end

  def returns(result)
    @object.send(:define_singleton_method, method) { |param| result }
    result
  end
end
