class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|
      self.metaclass.send(:define_method, method_name) do
        return return_value
      end
    end
  end
end

class Object
  def metaclass
    class << self
      self
    end
  end

  def mock(method)
    Mock.new(OpenStruct.new(method))
  end

  def stub(method)
    method.each_pair do |method_name, return_value|
      self.metaclass.send(:define_method, method_name) do
        return return_value
      end
    end
  end
end

class User
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def hello
    "OG method"
  end
end

#Calling mock on an object creates a mock object with the method given
jeff = "hi"
mock = jeff.mock(:numbers => "123")
mock.numbers

#It also works without an object (really, with implied Main/Object), mimicking Mocha
nums = mock(:letters => "abc")
nums.letters

#Calling stub on an object creates or overrides the method given for the Class itself,
#This is as opposed to returning a mock object with the methods
lev = User.new("lev")
lev.hello
lev.stub(:hello => "Stubbed method")
lev.hello
