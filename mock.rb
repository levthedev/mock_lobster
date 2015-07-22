# class Calculator
#   operators = {:+ => "add", :- => "subtract", :* => "multiply", :/ => "divide"}
#
#   operators.each do |sym, str|
#     define_method("#{str}") do |*tuple|
#       sym.to_proc.call(*tuple)
#     end
#   end
# end

class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|  # => #<OpenStruct hi="123">
      self.class.send(:define_method, method_name) do     # => Mock
        return return_value                               # => "123"
      end                                                 # => :hi
    end                                                   # => {:hi=>"123"}
  end
end
os = OpenStruct.new(:hi => "123")                         # => #<OpenStruct hi="123">
os.each_pair do |k,v|                                     # => #<OpenStruct hi="123">
  "#{k}: #{v}"                                            # => "hi: 123"
end                                                       # => {:hi=>"123"}

class String
  def stub(method)
    Mock.new(OpenStruct.new(method))  # => #<Mock:0x007fc663923700>
  end
end
jeff = "hi"                           # => "hi"
mock = jeff.stub(:hi => "123")        # => #<Mock:0x007fc663923700>
mock.methods - Object.methods         # => [:hi]
mock.hi                               # => "123"
