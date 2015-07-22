class Mock
  def initialize(open_struct)
    open_struct.each_pair do |method_name, return_value|
      self.class.send(:define_method, method_name) do
        return return_value
      end
    end
  end
end

class String
  def stub(method)
    Mock.new(OpenStruct.new(method))
  end
end

jeff = "hi"
mock = jeff.stub(:hi => "123")
mock.methods - Object.methods
mock.hi
