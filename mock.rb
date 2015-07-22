class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|  # => #<OpenStruct hi="123">, #<OpenStruct hi="456">
      self.class.send(:define_method, method_name) do     # => Mock, Mock
        return return_value                               # => "123", "456"
      end                                                 # => :hi, :hi
    end                                                   # => {:hi=>"123"}, {:hi=>"456"}
  end
end

class Object
  def mock(method)
    Mock.new(OpenStruct.new(method))  # => #<Mock:0x007fe619920d40>, #<Mock:0x007fe61991b610>
  end

  def stub(method)
    method.each_pair do |method_name, return_value|    # => {:hello=>"Stubbed method"}, {:hello=>"Stubbed method"}
      self.class.send(:define_method, method_name) do  # => User, User
        return return_value                            # => "Stubbed method", "Stubbed method", "Stubbed method"
      end                                              # => :hello, :hello
    end                                                # => {:hello=>"Stubbed method"}, {:hello=>"Stubbed method"}
  end
end

class User
  attr_accessor :name  # => nil

  def initialize(name)
    @name = name        # => "lev", "joe"
  end

  def hello
    "OG method"  # => "OG method"
  end
end

#Calling mock on an object creates a mock object with the method given
jeff = "hi"                     # => "hi"
mock = jeff.mock(:hi => "123")  # => #<Mock:0x007fe619920d40>
mock.hi                         # => "123"

#It also works without an object (really, with implied Main/Object), mimicking Mocha
nums = mock(:hi => "456")  # => #<Mock:0x007fe61991b610>
nums.hi                    # => "456"

#Calling stub on an object creates or overrides the method given for the Class itself,
#This is as opposed to returning a mock object with the methods
lev = User.new("lev")                 # => #<User:0x007fe61991a198 @name="lev">
lev.hello                             # => "OG method"
lev.stub(:hello => "Stubbed method")  # => {:hello=>"Stubbed method"}
lev.hello                             # => "Stubbed method"

#The biggest problem right now is stub overrides class methods, not singleton methods
joe = User.new("joe")                 # => #<User:0x007fe619913f00 @name="joe">
joe.hello                             # => "Stubbed method"
joe.stub(:hello => "Stubbed method")  # => {:hello=>"Stubbed method"}
joe.hello                             # => "Stubbed method"
