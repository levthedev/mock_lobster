class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|
      self.class.send(:define_method, method_name) do
        return return_value
      end
    end
  end
end

class Object
  def mock(method)
    Mock.new(OpenStruct.new(method))
  end

  def stub(method)
    method.each_pair do |method_name, return_value|
      self.class.send(:define_method, method_name) do
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

jeff = "hi"
mock = jeff.mock(:hi => "123")
mock.hi

nums = mock(:hi => "456")
nums.hi

lev = User.new("lev")
lev.hello
lev.stub(:hello => "Stubbed method")
lev.hello
