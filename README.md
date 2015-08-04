# mock_lobster
a tiny, lightweight mocking library

###useage
calling ```stubbify``` on any object with a hash as an argument adds the method to the object ```stubbify``` was called on, where the key is the method name and the value is the return value of said method.
for example, ```User.last.stubbify(:username => 'john smith')``` creates a method ```username``` on the object ```User.last``` with a return value of ```'john smith```. If the method already exists, it is overridden for this *particular instance* of the ```User``` class - i.e., the method being created by mock is a singleton method.

calling ```mock``` creates a ```Mock``` object, which has the methods given as a hash to the argument list of ```mock```.
for example, ```user_mock = mock(username: "john smith", password: "insecurepassword")``` creates a ```Mock``` objects with the methods ```username``` and ```password```, which return ```john smith``` and ```insecurpassword``` respectively.

calling ```reset``` will revert stubbed methods back to their original return values - this feature is a WIP, so please report any bugs you encounter.

###stubbify vs mock
stubs are useful when you want to redefine or add methods to an existing class. mocks are useful when you want to fake an instance of a class.

for example, if you want to test that a method ```twitter_stream(user)``` returns an array of tweets from a given user, you can create a mock object with the method called in ```twitter_stream``` - say, ```tweets```, and have it return a plausible array. this lets you test the logic in your methods without making costly API or database queries.

```mocked_user = mock(:tweets => ["tweet1", "tweet2"]```

```assert_equal twitter_stream(mocked_user), ["tweet1", "tweet2"]```

on the other hand, if you want to use a real user object (perhaps because it has many attributes and you do not wish to mock them all out), then stubbing is the way to go. mock lobster will create singleton methods that are undefined in a stub and will override methods that are already defined. to reset the overridden method back to the original value, call ```reset``` on the object you stubbed.

generally, it is a good idea to call ```reset``` on any objects you modified in your ```teardown``` method in minitest, or in a ```before``` or ```after``` block in rspec.

![mock lobster](/mock_lobster/blob/master/screenshots/Screen%20Shot%202015-08-04%20at%2011.13.21%20AM.png?raw=true)

###gem
this is now a gem - see https://rubygems.org/gems/mock_lobster

run ```gem install mock_lobster``` to install it.
```require 'mock_lobster'``` in your test/spec file, test/spec helper, or wherever else you require files for your tests/specs.
