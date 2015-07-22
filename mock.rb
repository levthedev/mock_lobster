class Object
  def metaclass
    class << self
      self         # => #<Class:#<Mock:0x007ff97b004390>>, #<Class:#<Mock:0x007ff97a012ba8>>, #<Class:#<User:0x007ff97a011ed8>>, NilClass
    end
  end

  def mock(method)
    Mock.new(OpenStruct.new(method))  # => #<Mock:0x007ff97b004390>, #<Mock:0x007ff97a012ba8>
  end

  def stub(method)
    method.each_pair do |method_name, return_value|        # => {:hello=>"Stubbed method"}
      self.metaclass.send(:define_method, method_name) do  # => #<Class:#<User:0x007ff97a011ed8>>
        return return_value                                # => "Stubbed method"
      end                                                  # => :hello
    end                                                    # => {:hello=>"Stubbed method"}
  end

  def expect(method, param)
    Expectation.new(method, param, self)  # => #<Expectation:0x007ff97a0109e8 @method=:hello>, #<Expectation:0x007ff97a0104e8 @method=:hello>
  end
end

class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|   # => #<OpenStruct numbers="123">, #<OpenStruct letters="abc">
      self.metaclass.send(:define_method, method_name) do  # => #<Class:#<Mock:0x007ff97b004390>>, #<Class:#<Mock:0x007ff97a012ba8>>
        return return_value                                # => "123", "abc"
      end                                                  # => :numbers, :letters
    end                                                    # => {:numbers=>"123"}, {:letters=>"abc"}
  end
end

class Expectation
  attr_accessor :method, :self, :param   # => nil
  def initialize(method, param, object)
    @method = method                     # => :hello, :hello
  end

  def returns(result)
    @self.metaclass.send(:define_method, method) { |param| result }  # => :hello
    result                                                           # => "this is a test"
  end
end

class User
  attr_accessor :name  # => nil
  def initialize(name)
    @name = name        # => "lev"
  end

  def hello(message = "OG method")
    message                         # => "OG method"
  end
end

#Calling mock on an object creates a mock object with the method given
jeff = "hi"                          # => "hi"
mock = jeff.mock(:numbers => "123")  # => #<Mock:0x007ff97b004390>
mock.numbers                         # => "123"

#It also works without an object (really, with implied Main/Object), mimicking Mocha
nums = mock(:letters => "abc")  # => #<Mock:0x007ff97a012ba8>
nums.letters                    # => "abc"

#Calling stub on an object creates or overrides the method given for the Class itself,
#This is as opposed to returning a mock object with the methods
lev = User.new("lev")                 # => #<User:0x007ff97a011ed8 @name="lev">
lev.hello                             # => "OG method"
lev.stub(:hello => "Stubbed method")  # => {:hello=>"Stubbed method"}
lev.hello                             # => "Stubbed method"

#Calling expect with a param returns a return value
lev.expect(:hello, "testing")                            # => #<Expectation:0x007ff97a0109e8 @method=:hello>
lev.expect(:hello, "testing").returns("this is a test")  # => "this is a test"
