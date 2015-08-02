# mock_lobster
a tiny, lightweight mocking library

###useage
calling ```stubbify``` on any object with a hash as an argument adds the method to the object ```stubbify``` was called on, where the key is the method name and the value is the return value of said method.
for example, ```User.last.stubbify(:username => 'john smith')``` creates a method ```username``` on the object ```User.last``` with a return value of ```'john smith```. If the method already exists, it is overridden for this *particular instance* of the ```User``` class - i.e., the method being created by mock is a singleton method.

calling ```mock``` creates a ```Mock``` object, which has the methods given as a hash to the argument list of ```mock```.
for example, ```user_mock = mock(username: "john smith", password: "insecurepassword") creates a ```Mock``` objects with the methods ```username``` and ```password```, which return ```john smith``` and ```insecurpassword``` respectively.

calling ```reset``` will revert stubbed methods back to their original return values - please note, this feature is not fully implemented and is buggy. it currently only works on methods that don't take blocks; if you stub and then revert a method that takes a block, it will revert it to return the value you would get had you not passed it a block.

###stubbify vs mock
stubs are useful when you want to redefine or add methods to an existing class. mocks are useful when you want to fake an instance of a class.
for example, if you want to test that a method ```twitter_stream(user)``` returns an array of tweets from a given user, you can create a mock object with the method called in ```twitter_stream``` - say, ```tweets```, and have it return a plausible array. this lets you test the logic in your methods without making costly API or database queries.

on the other hand, if you want to use a real user object (perhaps because it has many attributes and you do not wish to mock them all out), then stubbing is the way to go.

###gem
this is now a gem - see https://rubygems.org/gems/mock_lobster

run ```gem install mock_lobster``` to install it.
