class Object
  def metaclass
    class << self
      self         # => #<Class:#<Mock:0x007fc8cc02f958>>, #<Class:#<Mock:0x007fc8cc02e288>>, #<Class:#<User:0x007fc8cc02d5b8>>
    end
  end

  def mock(method)
    Mock.new(OpenStruct.new(method))  # => #<Mock:0x007fc8cc02f958>, #<Mock:0x007fc8cc02e288>
  end

  def stub(method)
    method.each_pair do |method_name, return_value|
      self.metaclass.send(:define_method, method_name) do
        return return_value
      end
    end
  end

  def expect(method, param)
    Expectation.new(method, param, self)  # => #<Expectation:0x007fc8cc02ccf8 @method=:hello, @self=#<User:0x007fc8cc02d5b8 @name="lev">>, #<Expectation:0x007fc8cc02c500 @method=:hello, @self=#<User:0x007fc8cc02d5b8 @name="lev">>
  end
end

class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|   # => #<OpenStruct numbers="123">, #<OpenStruct letters="abc">
      self.metaclass.send(:define_method, method_name) do  # => #<Class:#<Mock:0x007fc8cc02f958>>, #<Class:#<Mock:0x007fc8cc02e288>>
        return return_value                                # => "123", "abc"
      end                                                  # => :numbers, :letters
    end                                                    # => {:numbers=>"123"}, {:letters=>"abc"}
  end
end

class Expectation
  attr_accessor :method, :self, :param   # => nil
  def initialize(method, param, object)
    @method = method                     # => :hello, :hello
    @self = object                       # => #<User:0x007fc8cc02d5b8 @name="lev">, #<User:0x007fc8cc02d5b8 @name="lev">
  end

  def returns(result)
    @self                                                            # => #<User:0x007fc8cc02d5b8 @name="lev">
    @self.metaclass.send(:define_method, method) { |param| result }  # => :hello
    result                                                           # => "this is a test"
  end
end

class User
  attr_accessor :name   # => nil
  def initialize(name)
    @name = name        # => "lev"
  end

  def hello(message = "OG method")
    message                         # => "OG method", "OG method"
  end
end

#Calling mock on an object creates a mock object with the method given
jeff = "hi"                          # => "hi"
mock = jeff.mock(:numbers => "123")  # => #<Mock:0x007fc8cc02f958>
mock.numbers                         # => "123"

#It also works without an object (really, with implied Main/Object), mimicking Mocha
nums = mock(:letters => "abc")  # => #<Mock:0x007fc8cc02e288>
nums.letters                    # => "abc"

#Calling stub on an object creates or overrides the method given for the Class itself,
#This is as opposed to returning a mock object with the methods
lev = User.new("lev")  # => #<User:0x007fc8cc02d5b8 @name="lev">
lev.hello              # => "OG method"
#lev.stub(:hello => "Stubbed method")  # => {:hello=>"Stubbed method"}
lev.hello              # => "OG method"

#Calling expect with a param returns a return value
lev.expect(:hello, "testing")                            # => #<Expectation:0x007fc8cc02ccf8 @method=:hello, @self=#<User:0x007fc8cc02d5b8 @name="lev">>
lev.expect(:hello, "testing").returns("this is a test")  # => "this is a test"
lev.hello("testing")                                     # => "this is a test"
