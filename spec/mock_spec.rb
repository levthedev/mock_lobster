require_relative '../lib/mock_lobster.rb'
require 'rspec'

RSpec.describe 'Mock' do
  class User
    def initialize(name)
      @name = name
    end

    def hello(message = 'OG Method')
      message
    end

    def old_method
      "old_method"
    end

    def extra
      "extra_method"
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

      lev.stubbify(:hello => 'Stubbed Method')
      expect(lev.hello).to eq('Stubbed Method')

      b = User.new('jack')
      expect(b.old_method).to eq("old_method")
      b.stubbify(:old_method => "new_method")
      expect(b.old_method).to eq("new_method")

      c = User.new('joe')
      b.stubbify(:extra => "this is an extra method")

      expect(b.extra).to eq("this is an extra method")

      expect(c.old_method).to eq("old_method")

      b.reset
      expect(b.old_method).to eq("old_method")
      expect(b.extra).to eq("extra_method")
    end

    specify 'it creates new singleton methods when none are defined' do
      lev = User.new('lev')
      lev.stubbify(:goodbye => 'Some return value')
      expect(lev.goodbye).to eq('Some return value')
    end

    specify 'it creates singleton methods, not class methods' do
      joe = User.new('joe')
      expect(joe.hello).to eq('OG Method')
    end
  end

#  describe 'expect' do
#    specify 'it returns an expectation when expect is called on an object' do
#      lev = User.new('lev')
#      expectation = lev.expect(:hello, 'testing')
#      expect(expectation.class).to eq(Expectation)
#    end
#
#    specify 'it stubs the result of a method with the return value given' do
#      lev = User.new('lev')
#      lev.expect(:hello, 'testing').returns('this is a test')
#
#      expect(lev.hello('testing')).to eq('this is a test')
#    end
#  end
end
