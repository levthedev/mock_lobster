require_relative 'mock.rb'
require 'rspec'

RSpec.describe 'Mock' do
  class User
    def initialize(name)
      @name = name
    end

    def hello(message = 'OG Method')
      message
    end
  end

  specify 'it creates mock objects with appropriate methods' do
    mock = 'Number Collection'.mock(:numbers => '123')
    expect(mock.numbers).to eq('123')

    nums = mock(:letters => 'abc')
    expect(nums.letters).to eq('abc')
  end

  describe 'stub' do
    specify 'it replaces methods on objects' do
      lev = User.new('lev')
      expect(lev.hello).to eq('OG Method')

      lev.stub(:hello => 'Stubbed Method')
      expect(lev.hello).to eq('Stubbed Method')
    end

    specify 'it creates new singleton methods when none are defined' do
      lev = User.new('lev')
      lev.stub(:goodbye => 'Some return value')
      expect(lev.goodbye).to eq('Some return value')
    end

    specify 'it creates singleton methods, not class methods' do
      joe = User.new('joe')
      expect(joe.hello).to eq('OG Method')
    end
  end

  describe 'expect' do
    specify 'it returns an expectation when expect is called on an object' do
      lev = User.new('lev')
      expectation = lev.expect(:hello, 'testing')
      expect(expectation.class).to eq(Expectation)
    end

    specify 'it stubs the result of a method with the return value given' do
      lev = User.new('lev')
      lev.expect(:hello, 'testing').returns('this is a test')

      expect(lev.hello('testing')).to eq('this is a test')
    end
  end
end
